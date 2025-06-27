#!/bin/bash
set -e

# Define base installation directory
INSTALL_DIR="$HOME/chemsoft"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "----------------------------"
echo "Installing CREST 3.0.2"
echo "----------------------------"
wget -q https://github.com/grimme-lab/crest/releases/download/v3.0.2/crestLinuxV3-0-2.tgz
tar -xzf crestLinuxV3-0-2.tgz
mv crestLinuxV3-0-2 crest-3.0.2
echo 'export PATH="'"$INSTALL_DIR"'/crest-3.0.2:$PATH"' >> ~/.bashrc

echo "----------------------------"
echo "Installing XTB 6.5.1"
echo "----------------------------"
wget -q https://github.com/grimme-lab/xtb/releases/download/v6.5.1/xtb-6.5.1-linux-x86_64.tar.xz
tar -xf xtb-6.5.1-linux-x86_64.tar.xz
mv xtb-6.5.1-linux-x86_64 xtb-6.5.1
echo 'export PATH="'"$INSTALL_DIR"'/xtb-6.5.1/bin:$PATH"' >> ~/.bashrc

echo "----------------------------"
echo "Installing dependencies for Gromacs 2023.3"
echo "----------------------------"
sudo apt-get update
sudo apt-get install -y cmake build-essential fftw3 fftw3-dev

echo "----------------------------"
echo "Downloading and installing Gromacs 2023.3"
echo "----------------------------"
wget -q https://ftp.gromacs.org/gromacs/gromacs-2023.3.tar.gz
tar -xzf gromacs-2023.3.tar.gz
cd gromacs-2023.3
mkdir -p build
cd build
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR/gromacs-2023.3"
make -j $(nproc)
make install
echo 'source "'"$INSTALL_DIR"'/gromacs-2023.3/bin/GMXRC"' >> ~/.bashrc

echo "----------------------------"
echo "Installation complete."
echo "Please run: source ~/.bashrc"
echo "to update your PATH for crest, xtb, and gromacs."