#!/bin/bash
#
# Enhanced Installation Script

echo "Creating docker network..."
# Create docker shared network if not exist
if ! docker network ls --format "{{.Name}}" | grep -q "docker_shared_network"; then
  docker network create docker_shared_network
fi

echo "Retrive secrets from 1Password..."
# Set the Correct user account
export OP_ACCOUNT=B34KQ4M6NBGB5OUZVFO32PX35A

# Retrieve Username, Password, and Tailscale Auth Key
export UTILITY_SERVER_USERNAME=$(op read "op://Private/Utility Server/username")
export UTILITY_SERVER_PASSWORD=$(op read "op://Private/Utility Server/password")

echo "Installing docker container with compose file..."
docker-compose -p utility-server -f docker-compose.yml up --build -d

# Ensure the container is up and running
echo "Waiting for the container to start..."
sleep 10

echo "Streaming Docker logs..."
docker logs -f tailscale_subnet_router &

# Allow user to interrupt log streaming
read -p "Press [Enter] to continue once you've checked the logs."

# Configure Tailscale
echo "Setting up Tailscale on the subnet router..."
docker exec tailscale_subnet_router tailscale up \
  --reset \
  --advertise-routes=192.168.0.0/24,192.168.1.0/24 \
  --hostname="tailscale-subnet-router-home-network"

echo "Checking the status of Tailscale..."
docker exec tailscale_subnet_router tailscale status

# Retrieve device IP from Tailscale
DEVICE_IP=$(docker exec tailscale_subnet_router tailscale ip -4)
if [ -z "$DEVICE_IP" ]; then
  echo "Failed to retrieve device IP."
else
  echo "Device IP: $DEVICE_IP"
  echo "Finish the Setup with going to the Tailscale Admin Portal -> Manage Devices to allow the subnet routes: "
  echo "https://login.tailscale.com/admin/machines/${DEVICE_IP}"
fi
