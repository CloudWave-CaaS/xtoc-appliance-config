#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define the download directory
DOWNLOAD_DIR="$HOME/greenbone-community-container"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Update package lists and install prerequisites
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Uninstall conflicting packages
echo "Removing conflicting packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y $pkg || true
done

# Set up the Docker repository
echo "Setting up Docker repository..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create download directory
echo "Creating download directory at $DOWNLOAD_DIR..."
mkdir -p "$DOWNLOAD_DIR" && cd "$DOWNLOAD_DIR"

# Download the docker-compose file
echo "Downloading docker-compose file..."
curl -f -O https://greenbone.github.io/docs/latest/_static/docker-compose-22.4.yml

# Pull Greenbone Community Edition containers
echo "Pulling Greenbone Community Edition containers..."
docker compose -f "$DOWNLOAD_DIR/docker-compose-22.4.yml" -p greenbone-community-edition pull

# Start Greenbone Community Edition containers
echo "Starting Greenbone Community Edition containers..."
docker compose -f "$DOWNLOAD_DIR/docker-compose-22.4.yml" -p greenbone-community-edition up -d

# Set up admin user password
#read -s -p "Enter password for admin user: " password
#echo
#docker compose -f "$DOWNLOAD_DIR/docker-compose-22.4.yml" -p greenbone-community-edition \
#    exec -u gvmd gvmd gvmd --user=admin --new-password="$password"

echo "Setup complete. Access the Greenbone Security Assistant web interface at http://127.0.0.1:9392"
