#!/bin/bash

export RESET="\033[0m" YELLOW="\033[0;33m" GREEN="\033[0;32m"

echo -e "$YELLOW AGENT CONFIGURATION $RESET"
sudo apt-get update
sudo apt-get install -y curl
echo -e "$YELLOW K3S INSTALLATION $RESET"
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$(sudo cat /vagrant/token) INSTALL_K3S_EXEC="--node-ip 192.168.56.111 --flannel-iface eth1" sh -
echo -e "$YELLOW DELETING TOKEN $RESET"
sudo rm /vagrant/token
echo -e "$GREEN AGENT CONFIGURATION DONE $RESET"