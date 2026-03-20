# snaptastic

CLI screenshot beautifier. Watches a folder, beautifies screenshots with templates.

## What It Does

Takes screenshots (png/jpg/webp/tiff), applies a template (background + rounded corners + shadow + optional decorations), outputs a `-pretty` version next to the original. Works one-shot or as a folder watcher.

## Installing for the User

```bash
cd /Users/heymitch/repos/snaptastic
./install.sh
```

The installer:
1. Checks/installs `imagemagick` and `fswatch` via Homebrew
2. Copies `snaptastic` to `/usr/local/bin/`
3. Creates `~/.snaptastic/templates/` with bundled templates
4. Creates `~/.snaptastic/config` with defaults
5. Optionally installs a LaunchAgent for auto-start (answer y/n when prompted)

## Creating a Custom Template

Create a file at `~/.snaptastic/templates/<name>.sh`:

```bash
#!/usr/bin/env bash
TEMPLATE_NAME="my-template"
TEMPLATE_DESC="Description here"
BG_TYPE="solid"                      # "solid" or "gradient"
BG_COLOR="srgb(30,30,60)"           # MUST use srgb() — hex breaks on macOS
# For gradient: BG_GRADIENT_TOP="srgb(r,g,b)" and BG_GRADIENT_BOT="srgb(r,g,b)"
PADDING=60
CORNER_RADIUS=12
SHADOW_BLUR=20
SHADOW_OFFSET=6
SHADOW_COLOR="rgba(0,0,0,0.25)"

# Optional: custom decoration overlay
# decorate() {
#     local input="$1" output="$2"
#     magick "$input" ... "$output"
# }
```

CRITICAL: Always use `srgb()` for colors, never hex `#`. ImageMagick on macOS converts hex to grayscale.

## Setting Up Auto-Start

If skipped during install:
```bash
launchctl load ~/Library/LaunchAgents/com.snappretty.watcher.plist
```

To stop:
```bash
launchctl unload ~/Library/LaunchAgents/com.snappretty.watcher.plist
```

## Key Technical Notes

- Uses `srgb()` color notation — hex causes grayscale on macOS ImageMagick
- Watch mode catches Created + Renamed + MovedTo events (macOS screenshots use temp+rename)
- Files with `-pretty` in the name are skipped to prevent infinite loops
- Font paths are resolved at runtime via `fc-match` with macOS fallbacks
- Config at `~/.snaptastic/config`, templates at `~/.snaptastic/templates/`
