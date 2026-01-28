#!/bin/bash

set -e

# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: gum is not installed. Install it from https://github.com/charmbracelet/gum"
    exit 1
fi

gum style --foreground 135 "
  _   _                           _               
 | |_(_)_ __ __ _ _ __ ___   __ _(_)              
 | __| | '__/ _\` | '_ \` _ \ / _\` | |              
 | |_| | | | (_| | | | | | | (_| | |              
  \__|_|_|  \__,_|_| |_| |_|\__,_|_|              
  ____  _     ___           _       _     _       
 | __ )(_)___|_ _|_ __  ___(_) __ _| |__ | |_ ___ 
 |  _ \| |_  /| || '_ \/ __| |/ _\` | '_ \| __/ __|
 | |_) | |/ / | || | | \__ \ | (_| | | | | |_\__ \\
 |____/|_/___|___|_| |_|___/_|\__, |_| |_|\__|___/
                              |___/               
"
echo ""

# Domain name
DOMAIN=$(gum input --placeholder "Enter domain name (e.g., example.com)")

# IP address
IP_ADDRESS=$(gum input --placeholder "Enter IP address (e.g., 192.168.1.1)")

# AI Provider
AI_PROVIDER=$(gum choose "google" "openai" "anthropic")

# AI Model based on provider
case $AI_PROVIDER in
    google)
        AI_MODEL=$(gum choose "gemini-pro" "gemini-pro-vision" "gemini-1.5-pro" "gemini-1.5-flash")
        ;;
    openai)
        AI_MODEL=$(gum choose "gpt-4" "gpt-4-turbo" "gpt-3.5-turbo" "gpt-4o")
        ;;
    anthropic)
        AI_MODEL=$(gum choose "claude-3-opus-20240229" "claude-3-sonnet-20240229" "claude-3-haiku-20240307" "claude-3-5-sonnet-20241022")
        ;;
esac

# AI Provider API Key
AI_API_KEY=$(gum input --password --placeholder "Enter AI provider API key")

# Embedding Provider
EMBEDDING_PROVIDER=$(gum choose \
    "openai (text-embedding-3-small: 1536 dimensions)" \
    "openai (text-embedding-3-large: 3072 dimensions)" \
    "bedrock (amazon.titan-embed-text-v1: 1536 dimensions)" \
    "local (all-MiniLM-L6-v2: 384 dimensions)")

# Extract provider name
EMBEDDING_PROVIDER_NAME=$(echo $EMBEDDING_PROVIDER | cut -d' ' -f1)

# Super admin username
ADMIN_USERNAME=$(gum input --placeholder "Enter super admin username")

# Super admin password
ADMIN_PASSWORD=$(gum input --password --placeholder "Enter super admin password")

# Confirm password
ADMIN_PASSWORD_CONFIRM=$(gum input --password --placeholder "Confirm super admin password")

if [ "$ADMIN_PASSWORD" != "$ADMIN_PASSWORD_CONFIRM" ]; then
    echo "❌ Passwords do not match!"
    exit 1
fi

# Summary
echo ""
gum style --border normal --padding "1 2" --border-foreground 212 "
Configuration Summary:
━━━━━━━━━━━━━━━━━━━━━
Domain: $DOMAIN
IP Address: $IP_ADDRESS
AI Provider: $AI_PROVIDER
AI Model: $AI_MODEL
Embedding Provider: $EMBEDDING_PROVIDER
Admin Username: $ADMIN_USERNAME
"

# Confirm
gum confirm "Proceed with installation?" || exit 0

# Save configuration
cat > config.env << EOF
DOMAIN=$DOMAIN
IP_ADDRESS=$IP_ADDRESS
AI_PROVIDER=$AI_PROVIDER
AI_MODEL=$AI_MODEL
AI_API_KEY=$AI_API_KEY
EMBEDDING_PROVIDER=$EMBEDDING_PROVIDER_NAME
ADMIN_USERNAME=$ADMIN_USERNAME
ADMIN_PASSWORD=$ADMIN_PASSWORD
EOF

echo "✅ Configuration saved to config.env"
echo "🎉 Installation setup complete!"
