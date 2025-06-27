#!/bin/bash
set -e

# 1. Update system and install required packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential dkms wget curl linux-headers-$(uname -r)

# 2. Blacklist nouveau driver
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
sudo update-initramfs -u

# 3. Reboot prompt
echo -e "\n*** The system needs to reboot to unload the nouveau driver. ***"
read -p "Reboot now? (y/n): " REBOOT
if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    sudo reboot
    exit 0
else
    echo "Please reboot the system manually before running this script again."
    exit 1
fi

# Steps below will only run after reboot and re-execution.

# 4. Install NVIDIA driver (this part will run after reboot)
sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers autoinstall
sudo reboot

# 5. After reboot, install CUDA Toolkit 12.x (latest as of 2025)
# Download and install CUDA repository package
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.5.0/local_installers/cuda-repo-ubuntu2204-12-5-local_12.5.0-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-5-local_12.5.0-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-5-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

# 6. Add CUDA to PATH (for the current user)
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# 7. Check installation
nvidia-smi
nvcc --version

echo -e "\nNVIDIA Driver and CUDA Toolkit installation completed!"