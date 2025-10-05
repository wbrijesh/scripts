#!/bin/bash

# --- Configuration Variables ---

USER_NAME="brijesh"

# Your SSH public key (ed25519)
PUB_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvXoMy6TR772OrN1f3hvV/+zHr1LRXFvuOQri6I6kFe ops@brijesh.dev"

# --- 1. System Update and Package Installation ---

echo "Starting system update and package installation..."

# Update all packages
yum update -y

# Install necessary packages: firewalld and Fail2Ban
yum install -y firewalld fail2ban

# --- 2. Create New User and Set Up SSH Key ---
echo "Creating user '$USER_NAME' and setting up SSH key..."

# Create user if not exists
id -u $USER_NAME &>/dev/null || adduser $USER_NAME

# Add user to the 'wheel' group for sudo access on RHEL-based systems
usermod -aG wheel $USER_NAME

# Create .ssh directory and authorized_keys file
mkdir -p /home/$USER_NAME/.ssh

# Add the provided public key
echo "$PUB_KEY" > /home/$USER_NAME/.ssh/authorized_keys

# Set secure permissions
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
chmod 700 /home/$USER_NAME/.ssh
chmod 600 /home/$USER_NAME/.ssh/authorized_keys

# --- 3. SSH Hardening (/etc/ssh/sshd_config) ---

echo "Applying SSH hardening rules..."

SSH_CONFIG="/etc/ssh/sshd_config"

# Disable root login
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' $SSH_CONFIG
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' $SSH_CONFIG

# Disable password authentication
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONFIG
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONFIG

# --- 4. Firewalld Setup (Amazon Linux 2 Standard) ---

echo "Configuring firewalld..."
systemctl start firewalld
systemctl enable firewalld

# Allow permanent access for SSH (22), HTTP (80), and HTTPS (443)
firewall-cmd --zone=public --add-service=ssh --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent

# Apply the rules
firewall-cmd --reload

# --- 5. Fail2Ban Configuration ---

echo "Configuring and starting Fail2Ban..."
JAIL_LOCAL="/etc/fail2ban/jail.local"

# Create jail.local from the default config
cp /etc/fail2ban/jail.conf $JAIL_LOCAL

# Enable the SSH daemon filter in jail.local
sed -i '/^\[sshd\]/,/^maxretry/s/enabled = false/enabled = true/' $JAIL_LOCAL

# Set general bantime to 1 hour (3600 seconds)
sed -i 's/^bantime = 10m/bantime = 1h/' $JAIL_LOCAL

# Start and enable the service
systemctl start fail2ban
systemctl enable fail2ban

# --- 6. Final SSH Service Restart ---

echo "Restarting SSH service to load new configurations."
systemctl restart sshd

echo "Setup complete. You should now be able to SSH as 'brijesh' via key."

wget https://github.com/binwiederhier/ntfy/releases/download/v2.14.0/ntfy_2.14.0_linux_arm64.tar.gz
tar zxvf ntfy_2.14.0_linux_arm64.tar.gz
sudo cp -a ntfy_2.14.0_linux_arm64/ntfy /usr/bin/ntfy
sudo mkdir /etc/ntfy && sudo cp ntfy_2.14.0_linux_arm64/{client,server}/*.yml /etc/ntfy
ntfy publish brijeshwawdhane "Server configured: ${PUBLIC_IP}" --title "EC2 Setup Complete" --priority high