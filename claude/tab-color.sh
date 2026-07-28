#!/bin/bash
# iTerm2 tab-state indicator, driven by Claude Code hooks.
#   green  = processing        yellow = waiting for you        clear = done
# TTY is resolved via AppleScript once, then cached, so changes are instant.

STATE="$1"
GUID="${ITERM_SESSION_ID##*:}"
[ -z "$GUID" ] && exit 0

CACHE="$HOME/.claude/.tty-$GUID"
if [ -f "$CACHE" ]; then
  TTY=$(cat "$CACHE")
else
  TTY=$(osascript -e "tell application \"iTerm2\"
    repeat with w in windows
      repeat with t in tabs of w
        repeat with s in sessions of t
          if id of s is \"$GUID\" then return tty of s
        end repeat
      end repeat
    end repeat
  end tell" 2>/dev/null)
  [ -n "$TTY" ] && echo "$TTY" > "$CACHE"
fi
[ -z "$TTY" ] && exit 0

case "$STATE" in
  green)  printf '\033]6;1;bg;red;brightness;60\a\033]6;1;bg;green;brightness;200\a\033]6;1;bg;blue;brightness;110\a' > "$TTY" ;;
  yellow) printf '\033]6;1;bg;red;brightness;240\a\033]6;1;bg;green;brightness;190\a\033]6;1;bg;blue;brightness;20\a'  > "$TTY" ;;
  clear)  printf '\033]6;1;bg;*;default\a' > "$TTY" ;;
esac
exit 0
