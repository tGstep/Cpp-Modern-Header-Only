#!/bin/bash
set -e

echo "Installing required tools..."

if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed."
    exit 1
fi

if ! command -v g++ &> /dev/null && ! command -v clang++ &> /dev/null; then
    echo "Error: No supported C++ compiler found (g++ or clang++ required)."
    exit 1
fi

if ! command -v premake5 &> /dev/null; then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Installing Premake5 on Linux..."
        LATEST_URL=$(curl -s https://api.github.com/repos/premake/premake-core/releases/latest | grep "browser_download_url" | grep "linux" | cut -d '"' -f 4)
        wget $LATEST_URL -O premake.tar.gz
        tar -xvzf premake.tar.gz
        sudo mv premake5 /usr/local/bin/premake5
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Installing Premake5 on macOS..."
        brew install premake
    else
        echo "Unsupported OS"
        exit 1
    fi
fi

if ! command -v ninja &> /dev/null; then
    echo "Installing Ninja..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install ninja-build -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ninja
    fi
fi

if [ ! -d "external/vcpkg" ]; then
    echo "Cloning vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git external/vcpkg
    cd external/vcpkg
    ./bootstrap-vcpkg.sh
    cd ../..
fi

echo "All tools installed successfully."
