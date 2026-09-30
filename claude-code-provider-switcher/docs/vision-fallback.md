# Vision fallback (opt-in proxy)

Some providers mishandle pasted images, and the failure is silent: the model describes a
plausible picture it never received. Check your provider after every provider or model
change:

```bash
scripts/vision-probe.sh glm        # any profile name; --model to pin one
```

The probe sends an image drawn at run time (a color grid, so no cache can supply the answer)
and passes only if the reply names what it shows. `PASS` (exit 0): vision works, leave the
proxy off. `FAIL` (exit 1): turn the proxy on until a later probe passes. Exit 2 is a probe
error, not a verdict.

The proxy keeps requests without an image on the provider. A request that carries an image goes to
Anthropic whole: the conversation so far, including text, code and tool results, travels with it. Put a
pay-as-you-go Anthropic key in `~/.config/gephyra/anthropic-vision.env`:

```bash
ANTHROPIC_API_KEY=sk-ant-your-payg-key
# optional, overrides the gephyra.visionModel setting:
# GEPHYRA_VISION_MODEL=claude-haiku-4-5-20251001
```

then set **`gephyra.visionProxy: true`**. Image turns, and the tool loops they start, go to
Anthropic under that key (billed per use to it; your Claude subscription is untouched);
everything else goes to the provider unchanged. Only the model field of the redirected turns
is rewritten. The routing looks only at the last message, so a plain text follow-up returns
to the provider at once. If the proxy is unreachable, the wrapper connects to the provider
directly. The port is `gephyra.visionProxyPort` (default 4399, shared across windows); logs
go to `~/.config/gephyra/vision-proxy.log`.

How the proxy is built, and why it is the one exception to the no-proxy rule, is in
[decisions.md](decisions.md) (D-8).
