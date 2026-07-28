# dotfiles

Personal config, kept in git so it survives a machine loss.

## Claude Code — iTerm tab colours

`claude/` holds a Claude Code setup that tints the iTerm2 tab to show session state:

| Colour | Meaning |
|---|---|
| 🟢 green | Claude is working |
| 🟡 yellow | waiting on you (permission prompt or a question) |
| clear | turn finished |

`claude/tab-color.sh` writes iTerm2 `OSC 6` escape codes to the session's TTY. It resolves
the TTY once via AppleScript and caches it at `~/.claude/.tty-$GUID`, so colour changes are
instant. `claude/settings.json` wires it to nine Claude Code hook events — the important
pair being `PermissionRequest` (→ yellow the moment a prompt appears) and `PostToolUse`
(→ green the moment you answer).

## Usage

```sh
./install.sh   # repo  -> ~/.claude/   (run on a new machine)
./backup.sh    # ~/.claude/ -> repo    (run after editing config, then commit)
```

`install.sh` keeps a dated `.replaced-*` copy of anything it overwrites.

## Notes

- Claude Code updates install to `~/.local/share/claude/versions/` and never touch
  `~/.claude/`, so this config survives upgrades.
- Hook event names are the one upgrade risk: if a future version renames one, that colour
  change silently stops happening. Nothing errors — it just stops.
- If `settings.json` ever fails to parse, Claude Code ignores the **entire** file, not just
  the broken part. `install.sh` checks this with `jq` and warns.
