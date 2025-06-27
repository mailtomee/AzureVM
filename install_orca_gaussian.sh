#!/bin/bash
set -e

# Set installation directory
INSTALL_DIR="$HOME/chemsoft"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

#############################################
# 1. ORCA 5.0.4 (you must supply the installer)
#############################################
ORCA_ARCHIVE="orca_5_0_4_linux_x86-64_shared_openmpi411.tar.xz"
ORCA_DIR="orca-5.0.4"

if [ -f "$ORCA_ARCHIVE" ]; then
    echo "Extracting ORCA 5.0.4..."
    tar -xJf "$ORCA_ARCHIVE"
    # Find the extracted directory if not automatically named
    [ -d "$ORCA_DIR" ] || ORCA_DIR=$(find . -maxdepth 1 -type d -name 'orca_5_0_4_linux_x86-64_shared_openmpi411*' | head -1)
    mv "$ORCA_DIR" orca-5.0.4
    echo "export PATH=\"$INSTALL_DIR/orca-5.0.4:\$PATH\"" >> ~/.bashrc
    echo "export LD_LIBRARY_PATH=\"$INSTALL_DIR/orca-5.0.4:\$LD_LIBRARY_PATH\"" >> ~/.bashrc
    echo "ORCA 5.0.4 installed in $INSTALL_DIR/orca-5.0.4"
else
    echo "ERROR: ORCA 5.0.4 archive ($ORCA_ARCHIVE) not found in $INSTALL_DIR."
    echo "Please download it from https://orcaforum.kofo.mpg.de/app.php/dlext/ (login required) and place it in $INSTALL_DIR."
fi

#############################################
# 2. Gaussian 16 Rev.B.01 (you must supply the installer)
#############################################
GAUSS_ARCHIVE="g16_B.01_linux64.tar"
GAUSS_DIR="g16_B.01"

if [ -f "$GAUSS_ARCHIVE" ]; then
    echo "Extracting Gaussian 16 Rev.B.01..."
    mkdir -p "$GAUSS_DIR"
    cd "$GAUSS_DIR"
    tar -xvf "../$GAUSS_ARCHIVE"
    cd "$INSTALL_DIR"
    # Add Gaussian environment variables (edit as needed for your site/license)
    echo "export g16root=\"$INSTALL_DIR/$GAUSS_DIR\"" >> ~/.bashrc
    echo "export GAUSS_SCRDIR=\"/scratch/\$USER\"" >> ~/.bashrc
    echo 'export PATH="$g16root/g16:$PATH"' >> ~/.bashrc
    echo "Gaussian 16 Rev.B.01 extracted to $INSTALL_DIR/$GAUSS_DIR"
    echo "NOTE: You must configure your Gaussian license and (optionally) hosts file manually, according to your license terms."
else
    echo "ERROR: Gaussian 16 Rev.B.01 archive ($GAUSS_ARCHIVE) not found in $INSTALL_DIR."
    echo "Please place your licensed g16_B.01_linux64.tar in $INSTALL_DIR and re-run this script."
fi

echo "-------------------------------------------------"
echo "Installation steps (ORCA, Gaussian) completed."
echo "Run 'source ~/.bashrc' or open a new shell for new paths to take effect."
echo "If you see errors above, supply the missing archives and re-run."