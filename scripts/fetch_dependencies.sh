#!/bin/bash
set -e

if [ ! -d "external/vcpkg" ]; then
    echo "Error: vcpkg not found. Run scripts/install_tools.sh first."
    exit 1
fi

echo "Installing dependencies via vcpkg..."
cd external/vcpkg

# Get OS name
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)     TRIPLET="x64-linux";;
    Darwin*)    TRIPLET="x64-osx";;
    *)          echo "Unsupported OS: ${UNAME_OUT}"; exit 1;;
esac

./vcpkg install --triplet $TRIPLET
cd ../..

echo "Dependencies installed for $TRIPLET."
