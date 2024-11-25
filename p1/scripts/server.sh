#!/bin/bash

export RESET="\033[0m" YELLOW="\033[0;33m" GREEN="\033[0;32m"

echo -e "$YELLOW SERVER CONFIGURATION $RESET"
sudo apt-get update
sudo apt-get install -y curl
echo -e "$YELLOW K3S INSTALLATION $RESET"
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --flannel-iface eth1" sh -
echo -e "$YELLOW GENERATE TOKEN $RESET"
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token
chmod 600 /vagrant/token
echo -e "$GREEN SERVER CONFIGURATION DONE $RESET"