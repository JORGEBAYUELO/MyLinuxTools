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


# System Compatibility Check (RPM-based distros)
if [ -f /etc/fedora-release ]; then 
	echo "Running on Fedora..."
	PKG_MANAGER="dnf"
elif [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
	echo "Running on CentOS/RHEL..."
	PKG_MANAGER="yum"
else
	echo -e "${RED}This script is designed for RPM-based distributions (Fedora, CentOS, RHEL). Exiting.${NC}"
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


# Function to update system packages
update_system() {
	echo "Updating system packages..."
	sudo $PKG_MANAGER update -y
	check_status "System Update"
}


# Function to install Visual Studio Code
install_vscode() {
	check_installed code
	if [ $? -eq 0 ]; then
		if prompt_install "Visual Studio Code"; then
			echo "Installing Visual Studio Code..."
			sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
			sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
			sudo $PKG_MANAGER install -y code
			check_status "Visual Studio Code"
		fi
	fi
}


# Function to install kubernetes tools (kubectl)
install_kubernetes() {
	check_installed kubectl
	if [ $? -eq 0 ]; then
		if prompt_install "Kubernetes"; then 
			echo "Installing Kubernetes..."
			cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
			sudo yum install -y kubectl
			check_status "Kubernetes"
		fi
	fi
}


# Function to install Python 3
install_python() {
	check_installed python3
	if [ $? -eq 0 ]; then
		if prompt_install "Python 3"; then
			echo "Installing Python 3..."
			sudo $PKG_MANAGER install -y python3
			check_status "Python 3"
		fi
	fi
}


# Function to install Docker Desktop
install_docker() {
	check_installed docker
	if [ $? -eq 0 ]; then
		if prompt_install "Docker Desktop"; then
			echo "Installing Docker Desktop..."
			sudo $PKG_MANAGER config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
			sudo $PKG_MANAGER install -y docker-ce docker-ce-cli containerd.io
			check_status "Docker Desktop"
			sudo systemctl start docker
			check_status "Docker Service"
			sudo systemctl enable docker
			check_status "Docker Service Auto Start"
		fi
	fi
}


# Function to install GO programming language
install_go() {
	check_installed go
	if [ $? -eq 0 ]; then
		if prompt_install "GO"; then
			echo "Installing GO..."
			sudo $PKG_MANAGER install -y golang
			check_status "GO"
		fi
	fi
}


# Function to install Ansible
install_ansible() {
	check_installed ansible
	if [ $? -eq 0 ]; then
		if prompt_install "Ansible"; then
			echo "Installing Ansible..."
			sudo $PKG_MANAGER install -y ansible
			check_status "Ansible"
		fi
	fi
}


# Menu Display Function
show_menu() {
	echo "Select the tools you want to install (e.g., 1 3 5):"
	echo "1) Visual Studio Code"
	echo "2) Kubernetes"
	echo "3) Python 3"
	echo "4) Docker Desktop"
	echo "5) Go"
	echo "6) Ansible"
	echo "7) Exit"
}


# Get user input for tool selection
read_selection() {
	read -p "Enter the number(s) of the tool(s) to install: " selections
	for selection in $selections; do
		case $selection in
			1) install_vscode ;;
			2) install_kubernetes ;;
			3) install_python ;;
			4) install_docker ;;
			5) install_go ;;
			6) install_ansible ;;
			7) exit 0 ;;
			*) echo -e "${RED}Invalid option: $selection${NC}" ;;
		esac
	done
}


# Function for final cleanup and confirmation
final_cleanup() {
	echo "Cleaning up unnecessary packages..."
	sudo $PKG_MANAGER autoremove -y
	check_status "Cleanup"
	echo -e "${GREEN}All selected tools installed successfully!${NC}"
}


# Main function to run the script
main() {
	update_system
	show_menu
	read_selection
	final_cleanup
}


# Start the script 
main
