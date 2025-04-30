Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Output "Installing required tools..."

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git not found. Please install Git manually."
    exit 1
}

if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Write-Error "MSVC (cl.exe) compiler not found. Please install Visual Studio with C++ workloads."
    exit 1
}

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}

$env:PATH += ";$env:USERPROFILE\scoop\shims"

if (-not (Get-Command premake5 -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Premake5 via Scoop..."
    scoop install premake
}

if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Ninja via Scoop..."
    scoop install ninja
}

if (-not (Test-Path "external\vcpkg")) {
    Write-Output "Cloning vcpkg repository..."
    git clone https://github.com/microsoft/vcpkg.git external\vcpkg
    Push-Location external\vcpkg
    .\bootstrap-vcpkg.bat
    Pop-Location
}

Write-Output "All tools installed successfully."
