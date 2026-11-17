#!/bin/sh
# Container-local wrapper around xclip (real binary: /usr/bin/xclip).
# Why: on KWin/XWayland the X11 clipboard can hold stale text (e.g. left by the wl-copy shim's xclip)
# while the real image lives on the Wayland clipboard. xclip 0.13 then answers `-t image/png -o` with
# that stale text and exit code 0, so Claude Code (xclip first, wl-paste only on failure) saves garbage
# instead of the image. Reads of TARGETS and image/* from the clipboard go to wl-paste; everything else
# (including copy via -i) is passed through to the real xclip.
real=/usr/bin/xclip
t=""; out=0; sel=clipboard; prev=""
for a in "$@"; do
  case "$prev" in
    -t|-target) t=$a ;;
    -selection|-sel) sel=$a ;;
  esac
  case "$a" in
    -o|-out) out=1 ;;
  esac
  prev=$a
done
if [ "$out" = 1 ]; then
  case "$sel" in
    c*)  # clipboard (xclip accepts abbreviations of the selection name)
      case "$t" in
        TARGETS) exec wl-paste -l ;;
        image/*) exec wl-paste --type "$t" ;;
      esac ;;
  esac
fi
exec "$real" "$@"
