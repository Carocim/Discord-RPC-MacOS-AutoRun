#!/bin/bash
set -e

echo "⚙️ Setting up Discord RPC on macOS..."

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_PATH="$HOME/Library/LaunchAgents/com.discord.rpc.autorun.plist"

# Remove quarantine bit so macOS allows auto-start
xattr -dr com.apple.quarantine "$APP_DIR" 2>/dev/null || true

# Ensure required files exist
if [ ! -f "$APP_DIR/start.sh" ] || [ ! -f "$APP_DIR/server_macos_debug" ]; then
  echo "❌ Error: Missing files! start.sh and server_macos_debug must be in this folder."
  exit 1
fi

# Permissions
chmod +x "$APP_DIR/start.sh" "$APP_DIR/server_macos_debug"

# Fix line endings
sed -i '' -e 's/\r$//' "$APP_DIR/start.sh"

# Create LaunchAgent plist
cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.discord.rpc.autorun</string>

    <key>ProgramArguments</key>
    <array>
        <string>$APP_DIR/start.sh</string>
    </array>

    <key>WorkingDirectory</key>
    <string>$APP_DIR</string>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Reload the agent
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "✅ Done! Discord RPC will now auto-start every login."
echo "🔍 Test with: ps aux | grep server_macos_debug"
