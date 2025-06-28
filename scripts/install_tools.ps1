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

# Get project root directory (parent of scripts directory)
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ExternalDir = Join-Path $ProjectRoot "external"
$PremakeNinjaDir = Join-Path $ExternalDir "premake-ninja"

Write-Host "Project root: $ProjectRoot" -ForegroundColor Gray
Write-Host "External dir: $ExternalDir" -ForegroundColor Gray

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



# 6. Install premake-ninja module
if (-not (Test-Path $PremakeNinjaDir)) 
{
    Write-Host "Cloning premake-ninja module from Github..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $ExternalDir | Out-Null
    
    # Change to project root to run git clone
    Push-Location $ProjectRoot
    try {
        git clone https://github.com/jimon/premake-ninja.git premake-ninja
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n== All needed tools got bootstrapped successfully! ==" -ForegroundColor Green