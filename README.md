# Dockerized Tailscale with Subnet Routing

## Overview
This Docker setup creates a Tailscale container to enable subnet routing, allowing Tailscale to act as a bridge between the Tailscale network and your local network. This configuration facilitates secure and seamless connectivity between devices across these networks.

## Prerequisites
- Docker and Docker Compose must be installed on your host machine.
- A Tailscale account is necessary for setting up Tailscale authentication.

## Setup and Execution

### Step 1: Clone the Repository
First, clone the repository or download the files into a directory on your local machine.
```
git clone git@github.com:renehungerbuehler/tailscale_subnet_router.git
cd tailscale_subnet_router
```

### Step 2: Run install Script
Run the installation script and follow the instructions in the log output.
```
./install.sh
```
