#!/bin/bash

export RESET="\033[0m" YELLOW="\033[0;33m" GREEN="\033[0;32m"

echo -e "$YELLOW SERVER CONFIGURATION $RESET"
sudo apt-get update
sudo apt-get install -y curl

echo -e "$YELLOW DOCKER INSTALLATION $RESET"
# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version of docker:
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "$YELLOW K3S INSTALLATION $RESET"
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --flannel-iface eth1 --docker" sh -
echo -e "$GREEN SERVER CONFIGURATION DONE $RESET"
sudo kubectl apply -f /vagrant/deployments.yaml