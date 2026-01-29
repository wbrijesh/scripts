#!/bin/bash

set -e

INSTALLER_URL="https://raw.githubusercontent.com/wbrijesh/scripts/refs/heads/main/tiramai-bizinsights-installer.sh"
INSTALLER_FILE="/tmp/tiramai-installer-$$.sh"

echo "Downloading installer..."
curl -fsSL "$INSTALLER_URL" -o "$INSTALLER_FILE"
chmod +x "$INSTALLER_FILE"

exec "$INSTALLER_FILE"
