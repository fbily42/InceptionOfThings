#!/bin/bash

export RESET="\033[0m" YELLOW="\033[0;33m" GREEN="\033[0;32m"

if ! command -v curl &> /dev/null;then
    echo -e "$YELLOW Installing curl... $RESET"    
    sudo apt-get update -y
    sudo apt install curl -y
else
	echo -e "$GREEN Curl is already installed! $RESET"
fi

if ! command -v curl &> /dev/null;then
	echo -e "$YELLOW Installing argocd... $RESET"
	sudo brew install argocd
else
	echo -e "$GREEN ArgoCD is already installed! $RESET"
fi

if ! command -v docker &> /dev/null; then
    echo -e "$YELLOW Installing Docker... $RESET"
    # Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo -e \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    echo -e "$YELLOW Docker installed $RESET"
else
    echo -e "$GREEN Docker is already installed! $RESET"
fi

if ! command -v kubectl &> /dev/null; then
    echo -e "$YELLOW Installing kubectl... $RESET"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv ./kubectl /usr/bin/kubectl
    echo -e "$YELLOW Kubectl installed $RESET"
else
    echo -e "$GREEN Kubectl is already installed! $RESET"
fi

if ! command -v k3d &> /dev/null;then
    echo -e "$YELLOW Installing k3d... $RESET"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo -e "$YELLOW k3d installed $RESET"
else
    echo -e "$GREEN k3d is already installed! $RESET"
fi