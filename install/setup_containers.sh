#!/bin/bash

# Update package lists and install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker is already installed."
fi

# Create Docker volumes for persistent data
docker volume create ossec-data
docker volume create zeek-data
docker volume create chronicle-config

# Run OSSEC container
docker run -d \
    --name ossec-server \
    -v ossec-data:/var/ossec/data \
    -p 1514:1514/udp \
    -p 1515:1515 \
    atomicorp/ossec-docker

# Run Zeek container
docker run -d \
    --name zeek-container \
    -v zeek-data:/opt/zeek/logs \
    --network host \
    zeek/zeek:latest

# Placeholder for Chronicle Forwarder configuration
# Ensure you have the necessary configuration files in ~/chronicle-config
# Refer to Google's documentation for setting up the forwarder:
# https://cloud.google.com/chronicle/docs/forwarders/forwarder-installation

# Run Chronicle Forwarder container
docker run -d \
    --name chronicle-forwarder \
    --restart unless-stopped \
    --log-opt max-size=100m \
    --log-opt max-file=10 \
    --network host \
    -v ~/chronicle-config:/opt/chronicle/external \
    gcr.io/chronicle-container/cf_production_stable





# Verify all containers are running
docker ps

echo "Setup complete. OSSEC, Zeek, and Chronicle Forwarder containers are up and running."
