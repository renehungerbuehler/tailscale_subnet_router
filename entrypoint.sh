#!/bin/bash

# Enable IP forwarding
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

# Start Tailscale
tailscaled --socket=/tmp/tailscaled.sock &

# Wait a bit for tailscaled to start
sleep 5

# Authenticate and set up subnet routes using the environment variable for the auth key
tailscale --socket=/tmp/tailscaled.sock up --authkey=$TAILSCALE_AUTH_KEY --advertise-routes=192.168.0.0/24,192.168.1.0/24

# Keep the container running
wait
