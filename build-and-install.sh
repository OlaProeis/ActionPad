#!/bin/bash
# Build and install script for ActionPad

set -e  # Exit on error

echo "=========================================="
echo "  ActionPad - Build & Install"
echo "=========================================="
echo ""

# Check for required tools
if ! command -v cmake &> /dev/null; then
    echo "ERROR: cmake not found. Please install cmake."
    exit 1
fi

if ! command -v kpackagetool6 &> /dev/null; then
    echo "ERROR: kpackagetool6 not found. Please install KDE Plasma development tools."
    exit 1
fi

# Create build directory
mkdir -p build
cd build

echo "Running CMake..."
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release

echo ""
echo "Building C++ plugin..."
make -j$(nproc)

echo ""
echo "Installing..."
sudo make install

echo ""
echo "=========================================="
echo "  Installation complete!"
echo "=========================================="
echo ""
echo "To use the widget:"
echo "1. Restart Plasmashell: killall plasmashell && plasmashell &"
echo "2. Right-click on your panel or desktop"
echo "3. Select 'Add Widgets'"
echo "4. Search for 'Shortcut Widget'"
echo "5. Add and configure it!"
echo ""

