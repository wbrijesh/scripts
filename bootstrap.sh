#!/bin/bash

set -e

INSTALLER_URL="https://raw.githubusercontent.com/wbrijesh/scripts/refs/heads/main/tiramai-bizinsights-installer.sh"
INSTALLER_FILE="/tmp/tiramai-installer-$$.sh"

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed. Install it from https://github.com/charmbracelet/gum"
    exit 1
fi

gum spin --spinner dot --title "Downloading installer..." -- curl -fsSL "$INSTALLER_URL" -o "$INSTALLER_FILE"
chmod +x "$INSTALLER_FILE"

clear
exec "$INSTALLER_FILE"
