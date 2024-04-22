#!/bin/sh
set -e

#
# installation script
#

echo "Creating docker network..."
# Create docker shared network if not exist
networks=( $(docker network ls | awk '{print $2}' ) )

if [[ ! "${networks[@]}" =~ "docker_shared_network" ]]; then
  docker network create docker_shared_network
fi

echo "Get all secrets from 1Password CLI..."
# Set the Correct user account
export OP_ACCOUNT=B34KQ4M6NBGB5OUZVFO32PX35A

# Generic Username and Password
export UTILITY_SERVER_USERNAME=$(op read  "op://Private/Utility Server/username")
export UTILITY_SERVER_PASSWORD=$(op read  "op://Private/Utility Server/password")
export TAILSCALE_AUTH_KEY=$(op read  "op://Private/Utility Server/Tailscale Oauth Key")

# Install docker containers
echo "install docker container with compose file..."
docker compose -p utility-server -f docker-compose.yml up --build -d

# After the Docker container is running, we need to configure Tailscale to set up the subnet routes. 
# This step usually requires interactive authentication unless you're using an automated auth key.
echo "configure Tailscale to set up the subnet routes..."
docker exec -it tailscaled tailscale up --advertise-routes=192.168.0.0/24,192.168.1.0/24

echo "check the status of the tailscale socket..."
docker exec tailscaled tailscale --socket /tmp/tailscaled.sock status
