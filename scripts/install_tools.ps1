Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Utils ---

function Test-CommandInPath 
{
    param([string]$Command)
    return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

function Add-ToUserPath 
{
    param([string]$NewPath)
    if (-not (($env:PATH -split ";") -contains $NewPath)) 
    {
        Write-Host "Adding $NewPath to permanent user PATH..." -ForegroundColor Yellow
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if (-not ($currentPath -split ";" | Where-Object { $_ -eq $NewPath })) 
        {
            [Environment]::SetEnvironmentVariable("PATH", "$NewPath;$currentPath", "User")
        }
        $env:PATH = "$NewPath;$env:PATH"
    }
}

function Abort($Message) 
{
    Write-Host "ERROR: $Message" -ForegroundColor Red
    exit 1
}

# --- Main procedure ---

Write-Host "== Installing required tools... ==" -ForegroundColor Cyan

# 1. Check for Git and MSVC
if (-not (Test-CommandInPath "git")) 
{
    Abort "Git not found in PATH. Please install it manually."
}

if (-not (Test-CommandInPath "cl")) 
{
    Abort "MSVC (cl.exe) not found in PATH. Please install Visual Studio C++ Workload."
}


# 2. Check for Scoop and install it if not found
if (-not (Test-CommandInPath "scoop")) 
{
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}


# 3. Add Scoop' shims to user PATH
$ScoopShims = "$env:USERPROFILE\scoop\shims"
Add-ToUserPath -NewPath $ScoopShims
if ($env:GITHUB_PATH) 
{
    "$ScoopShims" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
}


# 4. Check for Ninja and install it if needed
if (-not (Test-CommandInPath "ninja")) 
{
    Write-Host "Installing Ninja the Scoop way..." -ForegroundColor Yellow
    scoop install ninja
}

if (-not (Test-CommandInPath "ninja")) 
{
    Abort "Ninja executable not found after the install process."
}


# 5. Install Premake
$PremakeBin = "$env:USERPROFILE\scoop\apps\premake\current\premake5.exe"
$LocalBin = "$env:USERPROFILE\.local\bin"

if ($env:GITHUB_PATH) 
{
    "$LocalBin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
}

if (-not (Test-CommandInPath "premake5")) 
{
    Write-Host "Installing Premake the Scoop way..." -ForegroundColor Yellow
    scoop install premake
}


# Copy in .local/bin if needed
if (-not (Test-CommandInPath "premake5") -and (Test-Path $PremakeBin)) 
{
    Write-Host "Copying premake5.exe in $LocalBin" -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $LocalBin | Out-Null
    Copy-Item $PremakeBin "$LocalBin\premake5.exe" -Force
    Add-ToUserPath -NewPath $LocalBin

    if ($env:GITHUB_PATH) 
    {
        Add-Content -Path $env:GITHUB_PATH -Value $LocalBin
    }
} 
elseif (-not (Test-CommandInPath "premake5")) 
{
    Abort "Premake executable not found after the install process."
}


# 6. Install premake-ninja module
if (-not (Test-Path "external\premake-ninja")) 
{
    Write-Host "Cloning premake-ninja module from Github..." -ForegroundColor Yellow
    git clone https://github.com/jimon/premake-ninja.git \premake-ninja
}

Write-Host "`n== All needed tools got bootstrapped successfully! ==" -ForegroundColor Green
