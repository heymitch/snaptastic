#!/usr/bin/env bash
set -euo pipefail

# snaptastic installer
# One command: curl -fsSL <url> | bash
# Or: git clone ... && cd snaptastic && ./install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="${HOME}/.snaptastic"
TEMPLATES_DIR="${CONFIG_DIR}/templates"
LAUNCH_AGENT_DIR="${HOME}/Library/LaunchAgents"
LAUNCH_AGENT_PLIST="com.snappretty.watcher.plist"

log() { echo "[snaptastic] $*"; }
err() { echo "[snaptastic] ERROR: $*" >&2; }

# ─── Check OS ────────────────────────────────────────────────

OS="$(uname -s)"
if [[ "$OS" != "Darwin" ]]; then
    log "Note: snaptastic is built for macOS. It may work on Linux with imagemagick + inotifywait."
    log "Continuing anyway..."
fi

# ─── Dependencies ────────────────────────────────────────────

log "Checking dependencies..."

if ! command -v brew &>/dev/null && [[ "$OS" == "Darwin" ]]; then
    err "Homebrew is required. Install from https://brew.sh"
    exit 1
fi

install_if_missing() {
    local cmd="$1"
    local pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        log "Installing $pkg..."
        brew install "$pkg"
    else
        log "✓ $cmd found"
    fi
}

if [[ "$OS" == "Darwin" ]]; then
    # ImageMagick — the magick command
    if ! command -v magick &>/dev/null; then
        log "Installing imagemagick..."
        brew install imagemagick
    else
        log "✓ imagemagick found"
    fi

    install_if_missing fswatch fswatch
fi

# ─── Install script ──────────────────────────────────────────

log "Installing snaptastic to ${INSTALL_DIR}..."

if [[ ! -d "$INSTALL_DIR" ]]; then
    sudo mkdir -p "$INSTALL_DIR"
fi

sudo cp "${SCRIPT_DIR}/snaptastic" "${INSTALL_DIR}/snaptastic"
sudo chmod +x "${INSTALL_DIR}/snaptastic"

# ─── Setup config directory ──────────────────────────────────

log "Setting up config at ${CONFIG_DIR}..."

mkdir -p "$TEMPLATES_DIR"

# Copy bundled templates
if [[ -d "${SCRIPT_DIR}/templates" ]]; then
    for t in "${SCRIPT_DIR}/templates"/*.sh; do
        [[ -f "$t" ]] || continue
        local_name="$(basename "$t")"
        if [[ ! -f "${TEMPLATES_DIR}/${local_name}" ]]; then
            cp "$t" "${TEMPLATES_DIR}/${local_name}"
            log "  Installed template: ${local_name%.sh}"
        else
            log "  Template exists (skipped): ${local_name%.sh}"
        fi
    done
fi

# Create default config if missing
if [[ ! -f "${CONFIG_DIR}/config" ]]; then
    cat > "${CONFIG_DIR}/config" <<'EOF'
# snaptastic configuration
# Uncomment and edit as needed

# Watch directory (default: ~/Desktop)
# WATCH_DIR="${HOME}/Desktop"

# Default template (default: clean-white)
# TEMPLATE="clean-white"

# Output suffix (default: -pretty)
# OUTPUT_SUFFIX="-pretty"
EOF
    log "  Created default config"
fi

# ─── Optional: LaunchAgent ────────────────────────────────────

echo ""
read -rp "[snaptastic] Install LaunchAgent for auto-start at login? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    mkdir -p "$LAUNCH_AGENT_DIR"

    cat > "${LAUNCH_AGENT_DIR}/${LAUNCH_AGENT_PLIST}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.snappretty.watcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>${INSTALL_DIR}/snaptastic</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>${HOME}/.snaptastic/snaptastic.log</string>
    <key>StandardErrorPath</key>
    <string>${HOME}/.snaptastic/snaptastic.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF

    log "LaunchAgent installed at ${LAUNCH_AGENT_DIR}/${LAUNCH_AGENT_PLIST}"
    log "Loading now..."
    launchctl load "${LAUNCH_AGENT_DIR}/${LAUNCH_AGENT_PLIST}" 2>/dev/null || true
    log "snaptastic will auto-start at login and is running now"
else
    log "Skipped LaunchAgent install"
    log "Run 'snaptastic' manually to start watch mode"
fi

echo ""
log "Installation complete!"
log ""
log "Usage:"
log "  snaptastic screenshot.png          # Beautify one file"
log "  snaptastic                          # Watch ~/Desktop for new screenshots"
log "  snaptastic --template gradient-dark # Use a different template"
log "  snaptastic --list-templates         # See available templates"
