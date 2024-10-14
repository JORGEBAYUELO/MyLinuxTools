# My Linux Tools

This repository contains a bash script that automates the installation of essential tools and software required for DevOps studies and RHCSA (Red Hat Certified System Administrator) preparation on **Fedora 40**.

## Features

This script will install the following tools:
- [Visual Studio Code](https://code.visualstudio.com/) - A popular code editor.
- [Kubernetes Tools](https://kubernetes.io/docs/tasks/tools/) - Tools like `kubectl`, `kubeadm`, and `kubelet` for Kubernetes cluster management.
- [Python 3](https://www.python.org/) - A versatile programming language.
- [Docker Desktop](https://www.docker.com/products/docker-desktop) - A containerization platform for application development.
- [Go](https://golang.org/) - A programming language designed for efficient software development.

### Additional Enhancements
- **Interactive Prompts**: You can selectively install the tools by responding to the prompts during script execution.
- **Error Handling**: Each step in the installation process includes checks to ensure the software installs correctly. The script provides clear feedback if an installation fails and stops further execution.
- **Color-coded Output**: Green text indicates a successful installation, and red text indicates a failure.
- **Logging**: The script logs all output to `setup_log.txt` for future reference.
- **Pre-checks**: The script checks if the tool is already installed before attempting to install it, to avoid redundant installations.

## Usage

1. Clone this repository:
    ```bash
    git clone https://github.com/JORGEBAYUELO/MyLinuxTools.git
    ```

2. Navigate to the directory:
    ```bash
    cd MyLinuxTools
    ```

3. Make the script executable:
    ```bash
    chmod +x mylinuxtools.sh
    ```

4. Run the script:
    ```bash
    ./mylinuxtools.sh
    ```

5. Follow the prompts to choose which tools to install.

## Logging

The script logs all installation processes and results to `setup_log.txt`. You can review this file to see detailed output.

## Requirements

- Fedora 40

## Contributing

Feel free to open issues or pull requests if you encounter any problems or want to improve the script.
