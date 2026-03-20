# snaptastic

Take a screenshot. Get a beautiful version. That's it.

`snaptastic` watches a folder for new screenshots and instantly generates beautified versions with backgrounds, rounded corners, and shadows. Or use it one-shot on any image.

## Install

```bash
git clone https://github.com/heymitch/snaptastic.git
cd snaptastic
./install.sh
```

The installer checks for `imagemagick` and `fswatch` (installs via Homebrew if missing), copies the script to `/usr/local/bin/`, sets up templates at `~/.snaptastic/`, and optionally installs a LaunchAgent for auto-start.

## Usage

```bash
# Beautify a single file
snaptastic screenshot.png

# Watch ~/Desktop for new screenshots (runs forever)
snaptastic

# Use a specific template
snaptastic --template gradient-dark screenshot.png

# Watch a different folder
snaptastic --watch-dir ~/Screenshots

# List available templates
snaptastic --list-templates
```

Output lands next to the original with a `-pretty` suffix: `screenshot.png` becomes `screenshot-pretty.png`.

## Templates

Four built-in templates ship out of the box:

| Template | Description |
|---|---|
| `clean-white` | White background, subtle shadow. The default. |
| `gradient-dark` | Deep navy-to-charcoal gradient, strong shadow. |
| `gradient-sunset` | Coral-to-purple gradient. Modern, colorful. |
| `minimal-gray` | Light gray, barely-there shadow. Maximum restraint. |

### Create Your Own

Templates are bash files that export variables. Drop them in `~/.snaptastic/templates/`.

```bash
#!/usr/bin/env bash
# ~/.snaptastic/templates/my-brand.sh

TEMPLATE_NAME="my-brand"
TEMPLATE_DESC="My brand colors"
BG_TYPE="solid"                    # "solid" or "gradient"
BG_COLOR="srgb(30,30,60)"         # MUST use srgb(), NOT hex
PADDING=60
CORNER_RADIUS=12
SHADOW_BLUR=20
SHADOW_OFFSET=6
SHADOW_COLOR="rgba(0,0,0,0.25)"
```

For gradients, use `BG_TYPE="gradient"` and set `BG_GRADIENT_TOP` and `BG_GRADIENT_BOT` instead of `BG_COLOR`.

**Important: Use `srgb()` color notation, not hex `#`.** ImageMagick on macOS converts hex values to grayscale. This will save you an hour of debugging.

### Advanced: Decoration Function

Templates can define a `decorate()` function for custom overlays (watermarks, stripes, metadata):

```bash
decorate() {
    local input="$1"
    local output="$2"
    # Add a timestamp watermark
    local font
    font="$(fc-match --format='%{file}' 'sans-serif')"
    magick "$input" \
        -font "$font" -pointsize 14 \
        -fill "rgba(255,255,255,0.5)" \
        -gravity SouthEast -annotate +20+20 "$(date +%Y-%m-%d)" \
        "$output"
}
```

## Config

Edit `~/.snaptastic/config` to change defaults:

```bash
# Watch directory
WATCH_DIR="${HOME}/Desktop"

# Default template
TEMPLATE="clean-white"

# Output suffix
OUTPUT_SUFFIX="-pretty"
```

## Auto-Start at Login

The installer offers to set up a LaunchAgent. If you skipped it:

```bash
# Create the plist manually
cat > ~/Library/LaunchAgents/com.snappretty.watcher.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.snappretty.watcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/snaptastic</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>~/.snaptastic/snaptastic.log</string>
    <key>StandardErrorPath</key>
    <string>~/.snaptastic/snaptastic.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF

# Load it
launchctl load ~/Library/LaunchAgents/com.snappretty.watcher.plist
```

To stop: `launchctl unload ~/Library/LaunchAgents/com.snappretty.watcher.plist`

## AI Agent Install

Using Claude Code, Codex, or similar? Tell your agent:

> Install snaptastic from ~/repos/snaptastic. Run ./install.sh, accept defaults, skip the LaunchAgent. Then beautify this screenshot for me.

## Dependencies

- **ImageMagick** (`brew install imagemagick`) — image processing
- **fswatch** (`brew install fswatch`) — filesystem watching (watch mode only)

## How It Works

1. Detects new screenshots (watches for Created + Renamed + MovedTo events, because macOS screenshots write to a temp file then rename)
2. Loads the selected template (variables + optional decoration function)
3. Rounds corners on the original screenshot
4. Creates a background (solid or gradient)
5. Generates a drop shadow
6. Composites: background + shadow + rounded screenshot
7. Runs optional `decorate()` from template
8. Saves the result with `-pretty` suffix

Files with `-pretty` in the name are automatically skipped to avoid infinite loops.

## License

MIT. See [LICENSE](LICENSE).
