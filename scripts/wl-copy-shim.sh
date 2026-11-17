#!/bin/sh
# Container-local shim: route wl-copy to X11 (xclip).
# Why: KWin only offers ext-data-control, which wl-clipboard 2.2.1 cannot use, so a bare wl-copy
# never reaches host clipboard clients (Klipper, KWrite). xclip goes through XWayland and works.
# Claude Code prefers wl-copy over xclip when WAYLAND_DISPLAY is set, hence the shim.
# Handles: [--primary|-p] [--clear|-c]; other wl-copy flags are ignored.
sel=clipboard; clear=0
for a in "$@"; do
  case "$a" in
    -p|--primary) sel=primary ;;
    -c|--clear) clear=1 ;;
  esac
done
if [ "$clear" = 1 ]; then exec xclip -selection "$sel" -i </dev/null >/dev/null 2>&1; fi
exec xclip -selection "$sel" -i >/dev/null 2>&1
