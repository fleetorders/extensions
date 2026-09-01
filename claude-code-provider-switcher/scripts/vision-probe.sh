#!/bin/sh
# vision-probe.sh — is the provider's image input actually GROUNDED on this version?
#
# The failure this checks for is silent and directionally dangerous: a gateway
# that mangles image input does not say "I can't see this" — the model produces
# a plausible description of a picture it never received and asserts it (seen
# live twice, mid-2026 and again on a later provider version, same signature).
# Text and code work stays correct throughout, which is why nobody notices.
#
# So the probe sends one image whose content is known BY CONSTRUCTION — a 2×2
# grid of solid squares in four colors drawn at run time, never from disk, so
# the expected answer cannot leak into any cache — and passes only if the reply
# names those four colors and none of the decoys. Run it after every provider
# or model version change, before a real session relies on vision.
#
#   scripts/vision-probe.sh [profile]        default profile: glm
#     --model <id>                           override the model probed
#
# Exit 0  PASS — native vision is grounded; the vision proxy can stay off.
# Exit 1  FAIL — the reply did not ground the image; turn the proxy on
#               (`gephyra.visionProxy: true`) until a later probe passes.
# Exit 2  probe error (no profile, network, non-JSON reply) — a warning, not a
#         verdict. The probe fails OPEN: an error never claims vision is broken.
#
# Credentials: reads ANTHROPIC_BASE_URL and ANTHROPIC_AUTH_TOKEN (or
# ANTHROPIC_API_KEY) from ~/.config/gephyra/<profile>.env at run time. The
# token goes into the request header only — it is never printed.
set -u

PROFILE="glm"
MODEL_OVERRIDE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --model) MODEL_OVERRIDE="${2:-}"; shift 2 ;;
    -*) echo "vision-probe: unknown flag $1" >&2; exit 2 ;;
    *) PROFILE="$1"; shift ;;
  esac
done

ENVF="$HOME/.config/gephyra/$PROFILE.env"
[ -f "$ENVF" ] || { echo "VISION-PROBE ERROR — no profile env at ~/.config/gephyra/$PROFILE.env"; exit 2; }

BASE=$(sed -n 's/^ANTHROPIC_BASE_URL=//p' "$ENVF" | head -1 | sed 's:/*$::')
TOKEN=$(sed -n 's/^ANTHROPIC_AUTH_TOKEN=//p' "$ENVF" | head -1)
[ -n "$TOKEN" ] || TOKEN=$(sed -n 's/^ANTHROPIC_API_KEY=//p' "$ENVF" | head -1)
MODEL="$MODEL_OVERRIDE"
[ -n "$MODEL" ] || MODEL=$(sed -n 's/^ANTHROPIC_MODEL=//p' "$ENVF" | head -1)
# Same reading of a profile the extension uses: any *_MODEL* line names a model
# this provider serves; the first is the probe's default when none is pinned.
[ -n "$MODEL" ] || MODEL=$(sed -n 's/^[A-Z0-9_]*_MODEL[A-Z0-9_]*=//p' "$ENVF" | head -1)
# Profiles quote values and may carry a wrapper-side length tag (model[1m]);
# the raw API takes the bare code.
MODEL=$(printf '%s' "$MODEL" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'\$//" -e 's/\[.*\]$//')
[ -n "$BASE" ] || { echo "VISION-PROBE ERROR — no ANTHROPIC_BASE_URL in $PROFILE.env"; exit 2; }
[ -n "$TOKEN" ] || { echo "VISION-PROBE ERROR — no ANTHROPIC_AUTH_TOKEN / ANTHROPIC_API_KEY in $PROFILE.env"; exit 2; }
[ -n "$MODEL" ] || { echo "VISION-PROBE ERROR — no model: set ANTHROPIC_MODEL in $PROFILE.env or pass --model"; exit 2; }

WORK=$(mktemp -d -t vision-probe) || exit 2
trap 'rm -rf "$WORK"' EXIT

# ---- the image: drawn now, in-process, stdlib only --------------------------
# Four colors sampled from six maximally-distinct names; the two left out are
# the decoys. A model that answers from a confabulated image has ~1/15 odds of
# naming the right four even before it must also avoid both decoys.
python3 - "$WORK" <<'PY' || { echo "VISION-PROBE ERROR — image generation failed"; exit 2; }
import base64, json, os, random, struct, sys, zlib

PALETTE = {
    "red": (220, 30, 30), "green": (30, 170, 30), "blue": (30, 60, 220),
    "yellow": (235, 220, 30), "orange": (240, 140, 20), "purple": (130, 30, 180),
}
names = random.sample(list(PALETTE), 4)
decoys = [n for n in PALETTE if n not in names]

CELL, W, H = 64, 128, 128
rows = []
for y in range(H):
    row = bytearray(b"\x00")  # filter: none
    for x in range(W):
        r, g, b = PALETTE[names[(y // CELL) * 2 + (x // CELL)]]
        row += bytes((r, g, b))
    rows.append(bytes(row))

def chunk(tag, data):
    return (struct.pack(">I", len(data)) + tag + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF))

png = (b"\x89PNG\r\n\x1a\n"
       + chunk(b"IHDR", struct.pack(">IIBBBBB", W, H, 8, 2, 0, 0, 0))
       + chunk(b"IDAT", zlib.compress(b"".join(rows)))
       + chunk(b"IEND", b""))

out = sys.argv[1]
open(os.path.join(out, "expected"), "w").write(" ".join(names))
open(os.path.join(out, "decoys"), "w").write(" ".join(decoys))
open(os.path.join(out, "body.json"), "w").write(json.dumps({
    "model": os.environ.get("VISION_PROBE_MODEL", ""),
    "max_tokens": 200,
    "messages": [{"role": "user", "content": [
        {"type": "image", "source": {"type": "base64", "media_type": "image/png",
                                     "data": base64.b64encode(png).decode()}},
        {"type": "text", "text":
         "This image is a 2 by 2 grid of solid colored squares. Name the color "
         "of each square in reading order: top-left, top-right, bottom-left, "
         "bottom-right. Answer with only the four color names."},
    ]}],
}))
PY
# The model is spliced in by python via env to keep the JSON quoting in one place.
VISION_PROBE_MODEL="$MODEL" python3 - "$WORK" <<'PY'
import json, os, sys
p = os.path.join(sys.argv[1], "body.json")
d = json.load(open(p))
d["model"] = os.environ["VISION_PROBE_MODEL"]
json.dump(d, open(p, "w"))
PY

# ---- one image-bearing call, the same shape a session's image turn has ------
HTTP=$(curl -sS -o "$WORK/reply.json" -w '%{http_code}' \
  --max-time 90 \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-api-key: $TOKEN" \
  -H "content-type: application/json" \
  -H "anthropic-version: 2023-06-01" \
  --data-binary @"$WORK/body.json" \
  "$BASE/v1/messages" 2>"$WORK/curl.err") || {
    echo "VISION-PROBE ERROR — request failed: $(head -1 "$WORK/curl.err")"; exit 2; }
if [ "$HTTP" != "200" ]; then
  echo "VISION-PROBE ERROR — HTTP $HTTP from $BASE/v1/messages (model $MODEL)"
  head -c 300 "$WORK/reply.json"; echo
  exit 2
fi

# ---- verdict: every expected color named, no decoy named --------------------
python3 - "$WORK" "$MODEL" "$PROFILE" <<'PY'
import json, re, sys
work, model, profile = sys.argv[1:4]
try:
    reply = json.load(open(f"{work}/reply.json"))
    text = " ".join(b.get("text", "") for b in reply.get("content", [])
                    if b.get("type") == "text").strip()
except (ValueError, AttributeError):
    print("VISION-PROBE ERROR — reply was not the expected messages JSON:")
    print("  " + open(f"{work}/reply.json", errors="replace").read()[:300])
    sys.exit(2)
if not text:
    print("VISION-PROBE ERROR — no text block in the reply:")
    print("  " + open(f"{work}/reply.json", errors="replace").read()[:300])
    sys.exit(2)

SYNONYMS = {"green": "green|lime", "purple": "purple|violet"}
def named(color, t):
    return re.search(r"\b(?:%s)\b" % SYNONYMS.get(color, color), t, re.I)

expected = open(f"{work}/expected").read().split()
decoys = open(f"{work}/decoys").read().split()
missing = [c for c in expected if not named(c, text)]
phantom = [c for c in decoys if named(c, text)]

if not missing and not phantom:
    print(f"VISION-PROBE PASS — vision grounded on {model} via {profile}: "
          f"reply named {', '.join(expected)}")
    sys.exit(0)
print(f"VISION-PROBE FAIL — the reply did not ground the generated image "
      f"(model {model} via {profile}).")
print(f"  expected: {', '.join(expected)}")
if missing:
    print(f"  not named: {', '.join(missing)}")
if phantom:
    print(f"  named but absent from the image: {', '.join(phantom)}")
print(f"  reply: {text[:300]}")
print("  → image turns are ungrounded on this version: set "
      "`gephyra.visionProxy: true` until a later probe passes.")
sys.exit(1)
PY
