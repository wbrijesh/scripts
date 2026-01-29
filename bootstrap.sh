#!/bin/bash

# Save script to temp file and re-execute with proper stdin
if [ "$BOOTSTRAP_REEXEC" != "1" ]; then
    TEMP_SCRIPT="/tmp/bootstrap-$$.sh"
    cat > "$TEMP_SCRIPT" << 'BOOTSTRAP_EOF'
#!/bin/bash

set -e

INSTALLER_URL="https://raw.githubusercontent.com/wbrijesh/scripts/refs/heads/main/tiramai-bizinsights-installer.sh"
INSTALLER_FILE="/tmp/tiramai-installer-$$.sh"

# Function to install gum
install_gum() {
    if command -v brew &> /dev/null; then
        brew install gum
    elif command -v apt-get &> /dev/null; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install -y gum
    elif command -v yum &> /dev/null; then
        echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
        sudo rpm --import https://repo.charm.sh/yum/gpg.key
        sudo yum install -y gum
    elif command -v zypper &> /dev/null; then
        echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
        sudo rpm --import https://repo.charm.sh/yum/gpg.key
        sudo zypper refresh
        sudo zypper install -y gum
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm gum
    elif command -v pkg &> /dev/null; then
        sudo pkg install -y gum
    else
        echo "Error: No supported package manager found. Please install gum manually from https://github.com/charmbracelet/gum"
        exit 1
    fi
}

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Installer has unmet dependencies."
    read -p "Would you like to install them? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_gum
    else
        echo "Installation cancelled."
        exit 1
    fi
fi

gum spin --spinner dot --title "Downloading installer..." -- sh -c "curl -fsSL '$INSTALLER_URL' -o '$INSTALLER_FILE'"
chmod +x "$INSTALLER_FILE"

clear
exec "$INSTALLER_FILE"
BOOTSTRAP_EOF
    
    chmod +x "$TEMP_SCRIPT"
    BOOTSTRAP_REEXEC=1 exec "$TEMP_SCRIPT"
fi
