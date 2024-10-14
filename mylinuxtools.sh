#!/bin/bash

# Define color variables
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"   # No Color


# Function to check the status of the last command
check_status() {
	if [ $? -eq 0 ]; then
		echo -e "${GREEN}$1 Installed Successfully!${NC}"
	else
		echo -e "${RED}Failed to Install $1.${NC}"
	fi
}


# System Compatibility Check (Fedora only)
if [ -f /etc/fedora-release ]; then 
	echo "Running on Fedora..."
else
	echo -e "${RED}This script is designed for Fedora. Exiting.${NC}"
	exit 1
fi


# Log output to file
exec > >(tee -i setup_log.txt)
exec 2>&1


# Function to check if a package is already installed
check_installed() {
	if command -v $1 &> /dev/null; then
		echo -e "${GREEN}$1 is already installed.${NC}"
		return 1
	fi
	return 0
}


# Function to prompt user for confirmation
prompt_install() {
	read -p "Do you want to install $1? (y/n): " choice
	case "$choice" in
		y|Y ) return 0 ;; # User chose to install
		n|N ) return 1 ;; # User chose not to install
		* ) echo "Invalid choice. Skipping $1."; return 1 ;;
	esac
}


# Update system packages
echo "Updating system packages..."
sudo dnf update -y
check_status "System Update"


# Install Visual Studio Code
check_installed code
if [ $? -eq 0 ]; then
	if prompt_install "Visual Studio Code"; then
		echo "Installing Visual Studio Code..."
		sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
		sudo dnf install -y code
		check_status "Visual Studio Code"
	fi
fi


# Install kubernetes tools (kubectl, kubeadm, kubelet)
check_installed kubectl
if [ $? -eq 0 ]; then
	if prompt_install "Kubernetes (kubectl, kubeadm, kubelet)"; then 
		echo "Installing Kubernetes (kubectl, kubeadm, kubelet)..."
		sudo dnf install -y kubernetes kubectl kubeadm kubelet
		check_status "Kubernetes"
		sudo systemctl enable --now kubelet 
		check_status "Kubelet Service"
	fi
fi


# Install Python 3
if [ $? -eq 0 ]; then
	if prompt_install "Python 3"; then
		echo "Installing Python 3..."
		sudo dnf install -y python3
		check_status "Python 3"
	fi
fi


# Install Docker Desktop
if [ $? -eq 0 ]; then
	if prompt_install "Docker Desktop"; then
		echo "Installing Docker Desktop..."
		sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
		sudo dnf install -y docker-ce docker-ce-cli containerd.io
		check_status "Docker Desktop"
		sudo systemctl start docker
		check_status "Docker Service"
		sudo systemctl enable docker
		check_status "Docker Service Auto Start"
	fi
fi


# Install GO programming language
if [ $? -eq 0 ]; then
	if prompt_install "GO"; then
		echo "Installing GO..."
		sudo dnf install -y golang
		check_status "GO"
	fi
fi


# Final cleanup and confirmation
echo "Cleaning up unnecessary packages..."
sudo dnf autoremove -y
check_status "Cleanup"


echo -e "${GREEN}All selected tools installed successfully!${NC}"
