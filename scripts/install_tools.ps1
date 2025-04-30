Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Output "Installing required tools..."

# 1. Verifica Git e MSVC
if (-not (Get-Command git -ErrorAction SilentlyContinue)) 
{
    Write-Error "Git not found. Please install Git manually."
    exit 1
}


if (-not (Get-Command cl -ErrorAction SilentlyContinue)) 
{
    Write-Error "MSVC (cl.exe) compiler not found. Please install Visual Studio with C++ workloads."
    exit 1
}

# 2. Installa Scoop se mancante
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) 
{
    Write-Output "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}
$env:PATH += ";$env:USERPROFILE\scoop\shims"

# 3. Installa Ninja
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) 
{
    Write-Output "Installing Ninja via Scoop..."
    scoop install ninja
}

# 4. Installa Premake5
if (-not (Get-Command premake5 -ErrorAction SilentlyContinue)) 
{
    Write-Output "Installing Premake5 via Scoop..."
    scoop install premake
    $env:PATH += ";$env:USERPROFILE\scoop\shims"
}

# 5. Clona vcpkg
if (-not (Test-Path "external\vcpkg")) 
{
    Write-Output "Cloning vcpkg repository..."
    git clone https://github.com/microsoft/vcpkg.git external\vcpkg
    Push-Location external\vcpkg
    .\bootstrap-vcpkg.bat
    Pop-Location
}

# 6. Clona premake-ninja
if (-not (Test-Path "external\premake-ninja")) 
{
    Write-Output "Cloning premake-ninja module..."
    git clone https://github.com/jimon/premake-ninja.git external\premake-ninja
}

Write-Output "All tools (Git, MSVC, Scoop, Ninja, Premake5, vcpkg, premake-ninja) installed successfully."