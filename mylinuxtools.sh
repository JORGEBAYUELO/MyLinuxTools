#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo dnf update -y

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code 

# Install kubernetes tools (kubectl, kubeadm, kubelet)
echo "Installing Kubernetes (kubectl, kubeadm, kubelet)..."
sudo dnf install -y kubernetes kubectl kubeadm kubelet
sudo systemctl enable --now kubelet 

# Install Python 3
echo "Installing Python 3..."
sudo dnf install -y python3

# Install Docker Desktop
echo "Installing Docker Desktop..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker 
sudo systemctl enable docker

# Install GO programming language
echo "Installing GO..."
sudo dnf install -y golang

# Final cleanup and confirmation
echo "Cleaning up..."
sudo dnf autoremove -y


echo "All tools installed successfully!"
