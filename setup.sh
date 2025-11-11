#!/bin/bash
set -e

echo "⚙️ Setting up Discord RPC on macOS..."

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_PATH="$HOME/Library/LaunchAgents/com.discord.rpc.autorun.plist"

if [ -f "$APP_DIR/start.sh" ]; then
  echo "🔧 Fixing line endings for start.sh..."
  sed -i '' -e 's/\r$//' "$APP_DIR/start.sh"
else
  echo "❌ Error: start.sh not found in this folder"
  exit 1
fi

if [ -f "$APP_DIR/start.sh" ] && [ -f "$APP_DIR/server_macos_debug" ]; then
  chmod +x "$APP_DIR/start.sh" "$APP_DIR/server_macos_debug"
else
  echo "❌ Error: Required scripts not found in this folder"
  exit 1
fi

cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.discord.rpc.autorun</string>
    <key>ProgramArguments</key>
    <array>
        <string>$APP_DIR/start.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "✅ Setup complete! Discord RPC will now auto-start on login."
echo "🔍 To check if it's running: ps aux | grep server_macos_debug"
