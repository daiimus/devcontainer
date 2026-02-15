#!/bin/bash
# Configure an Evennia game directory for GitHub Codespaces.
#
# Codespaces proxies each forwarded port through its own URL. Evennia's
# webclient needs to know the correct websocket URL for port 4002.

GAMEDIR="${1:?Usage: setup-codespace.sh <gamedir>}"
SECRET_SETTINGS="$GAMEDIR/server/conf/secret_settings.py"

if [ ! -f "$SECRET_SETTINGS" ]; then
    echo "Error: $SECRET_SETTINGS not found. Run 'evennia --init $GAMEDIR' first."
    exit 1
fi

if grep -q "WEBSOCKET_CLIENT_URL" "$SECRET_SETTINGS"; then
    echo "Websocket configuration already present in $SECRET_SETTINGS"
    exit 0
fi

cat >> "$SECRET_SETTINGS" << 'SETTINGS'

# Codespaces: tell the webclient where to find the websocket.
# Evennia serves its web page (4001) and websocket (4002) on separate ports.
# Codespaces proxies each port through its own URL, so the webclient needs
# the full websocket address rather than just a port number.
import os
CODESPACE_NAME = os.environ.get("CODESPACE_NAME")
if CODESPACE_NAME:
    DOMAIN = os.environ.get("GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN", "app.github.dev")
    WEBSOCKET_CLIENT_URL = f"wss://{CODESPACE_NAME}-4002.{DOMAIN}"
SETTINGS

echo "Codespaces websocket configuration added to $SECRET_SETTINGS"
