Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path "external\vcpkg")) {
    Write-Error "vcpkg not found. Run scripts/install_tools.ps1 first."
    exit 1
}

Write-Output "Installing dependencies via vcpkg..."
Push-Location external\vcpkg
.\vcpkg install --triplet x64-windows
Pop-Location

Write-Output "Dependencies installed."