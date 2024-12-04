#!/bin/bash

# Variables
WEBROOT_SOURCE="/mnt/xtoc-appliance-config/var/www/xtoc-config/*"
WEBROOT_DEST="/var/www/xtoc-config"
SERVICE_NAME="xtoc-config"
NODE_VERSION="20.x"  # Update as needed

set -e  # Exit immediately if a command fails

echo "Updating system and installing dependencies..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git build-essential

echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | sudo -E bash -
sudo apt install -y nodejs

echo "Verifying Node.js installation..."
node -v
npm -v

echo "Creating webroot destination at $WEBROOT_DEST..."
sudo mkdir -p "$WEBROOT_DEST"
sudo cp -r $WEBROOT_SOURCE "$WEBROOT_DEST"
sudo chown -R $USER:$USER "$WEBROOT_DEST"

echo "Installing application dependencies..."
cd "$WEBROOT_DEST"

# Install dependencies listed in package.json
if [ -f "package.json" ]; then
    npm install
else
    echo "No package.json found. Initializing and installing required dependencies..."
    npm init -y
    npm install basic-auth-connect express
fi

echo "Creating systemd service for $SERVICE_NAME..."
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=XTOC Appliance Config
After=network.target

[Service]
ExecStart=/usr/bin/node $WEBROOT_DEST/server.js
WorkingDirectory=$WEBROOT_DEST
Restart=always
User=$USER
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd and enabling the service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo "Setup complete. Check the service status with: sudo systemctl status $SERVICE_NAME"
