#!/bin/bash
set -e

echo "Installing required tools..."

# 1. Verifica Git e il compilatore C++
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed."
    exit 1
fi

if ! command -v g++ &> /dev/null && ! command -v clang++ &> /dev/null; then
    echo "Error: No supported C++ compiler found (g++ or clang++ required)."
    exit 1
fi

# 2. Installa Ninja se mancante
if ! command -v ninja &> /dev/null; then
    echo "Installing Ninja..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install ninja-build -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ninja
    else
        echo "Unsupported OS for Ninja installation"
        exit 1
    fi
fi

# 3. Installa Premake5 se mancante
if ! command -v premake5 &> /dev/null; then
    echo "Installing Premake5..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        LATEST_URL=$(
          curl -s https://api.github.com/repos/premake/premake-core/releases/latest \
          | grep "browser_download_url" \
          | grep "linux.tar.gz" \
          | cut -d '"' -f 4
        )
        wget "$LATEST_URL" -O premake.tar.gz
		tar -xzf premake.tar.gz
		sudo mv premake5 /usr/local/bin/premake5
		rm -f premake.tar.gz
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install premake
    else
        echo "Unsupported OS for Premake installation"
        exit 1
    fi
fi

# 4. Clona vcpkg se necessario
if [ ! -d "external/vcpkg" ]; then
    echo "Cloning vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git external/vcpkg
    cd external/vcpkg
    ./bootstrap-vcpkg.sh
    cd ../..
fi

# 5. Clona premake-ninja se necessario
if [ ! -d "external/premake-ninja" ]; then
    echo "Cloning premake-ninja module..."
    git clone https://github.com/jimon/premake-ninja.git external/premake-ninja
fi

echo "All tools (Git, compiler, Ninja, Premake5, vcpkg, premake-ninja) installed successfully."
