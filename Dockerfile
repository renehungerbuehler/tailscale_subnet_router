FROM ubuntu:20.04

# Avoid timezone prompt in apt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    iptables \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
RUN apt-get update && apt-get install -y tailscale

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
