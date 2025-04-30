#!/bin/bash
set -e

if [ ! -d "external/vcpkg" ]; then
    echo "Error: vcpkg not found. Run scripts/install_tools.sh first."
    exit 1
fi

echo "Installing dependencies via vcpkg..."
cd external/vcpkg
./vcpkg install --triplet x64-linux
cd ../..

echo "Dependencies installed."