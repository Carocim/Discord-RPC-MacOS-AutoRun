# Discord RPC macOS Auto-Start

This script helps run Discord Rich Presence on macOS automatically.  
It sets permissions, fixes line endings, and configures auto-start.

## Quick Setup

1. **Install the Discord RPC extension in your browser:**  
   - [Chrome](https://chrome.google.com/webstore/detail/discord-rich-presence/agnaejlkbiiggajjmnpmeheigkflbnoo)  
   - [Firefox](https://addons.mozilla.org/firefox/addon/discord-rich-presence/)

2. **Download the original Discord RPC files from the official release:**  
   - [GitHub Release 0.3.0](https://github.com/lolamtisch/Discord-RPC-Extension/releases/tag/0.3.0)  

   The folder should contain:  
   - `start.sh`  
   - `server_macos_debug`

3. **Download `setup.sh` from this fork** and place it in the **same folder** as the original files.

4. **Open Terminal in that folder** and follow these steps:

   **Make the main file executable:**  
   ```bash
   chmod +x ./server_macos_debug
   ```

   **Run the start script:**  
   ```bash
   ./start.sh
   ```

   **Make the setup script executable:**  
   ```bash
   chmod +x setup.sh
   ```

   **Execute setup:**  
   ```bash
   ./setup.sh
   ```

After this, the server will automatically run every time you log in.

## Verify

Check if the server is running:

```bash
ps aux | grep server_macos_debug
```

If you see a process for `server_macos_debug`, it’s running.

## Uninstall

To remove the auto-start and undo setup:

```bash
launchctl unload ~/Library/LaunchAgents/com.discord.rpc.autorun.plist
rm ~/Library/LaunchAgents/com.discord.rpc.autorun.plist
chmod -x ./server_macos_debug ./start.sh
```
