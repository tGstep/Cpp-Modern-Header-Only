Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Funzioni di utilità ---

function Test-CommandInPath {
    param([string]$Command)
    return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

function Add-ToUserPath {
    param([string]$NewPath)
    if (-not (($env:PATH -split ";") -contains $NewPath)) {
        Write-Host "Aggiunta di $NewPath alla PATH utente permanente..." -ForegroundColor Yellow
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if (-not ($currentPath -split ";" | Where-Object { $_ -eq $NewPath })) {
            [Environment]::SetEnvironmentVariable("PATH", "$NewPath;$currentPath", "User")
        }
        $env:PATH = "$NewPath;$env:PATH"
    }
}

function Abort($Message) {
    Write-Host "ERRORE: $Message" -ForegroundColor Red
    exit 1
}

# --- Inizio script ---

Write-Host "== Installazione strumenti richiesti ==" -ForegroundColor Cyan

# 1. Verifica Git e MSVC
if (-not (Test-CommandInPath "git")) {
    Abort "Git non trovato. Installalo manualmente: https://git-scm.com/downloads"
}

if (-not (Test-CommandInPath "cl")) {
    Abort "MSVC (cl.exe) non trovato. Installa Visual Studio con workload C++."
}

# 2. Installa Scoop se mancante
if (-not (Test-CommandInPath "scoop")) {
    Write-Host "Installazione Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}

# 3. Aggiungi shims di Scoop al PATH utente
$ScoopShims = "$env:USERPROFILE\scoop\shims"
Add-ToUserPath -NewPath $ScoopShims

# 4. Installa Ninja
if (-not (Test-CommandInPath "ninja")) {
    Write-Host "Installazione di Ninja via Scoop..." -ForegroundColor Yellow
    scoop install ninja
}
if (-not (Test-CommandInPath "ninja")) {
    Abort "Ninja non trovato dopo l'installazione."
}

# 5. Installa Premake5
$PremakeBin = "$env:USERPROFILE\scoop\apps\premake\current\premake5.exe"
$LocalBin = "$env:USERPROFILE\.local\bin"

if (-not (Test-CommandInPath "premake5")) {
    Write-Host "Installazione di Premake5 via Scoop..." -ForegroundColor Yellow
    scoop install premake
}

# Copia in .local/bin se necessario
if (-not (Test-CommandInPath "premake5") -and (Test-Path $PremakeBin)) {
    Write-Host "Copia di premake5.exe in $LocalBin" -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $LocalBin | Out-Null
    Copy-Item $PremakeBin "$LocalBin\premake5.exe" -Force
    Add-ToUserPath -NewPath $LocalBin

    # Se in GitHub Actions
    if ($env:GITHUB_PATH) {
        Add-Content -Path $env:GITHUB_PATH -Value $LocalBin
    }
} elseif (-not (Test-CommandInPath "premake5")) {
    Abort "Premake5 non disponibile dopo l'installazione."
}

# 6. Clona premake-ninja
if (-not (Test-Path "external\premake-ninja")) {
    Write-Host "Clonazione del modulo premake-ninja..." -ForegroundColor Yellow
    git clone https://github.com/jimon/premake-ninja.git external\premake-ninja
}

# 7. Clona e bootstrap vcpkg
if (-not (Test-Path "external\vcpkg")) {
    Write-Host "Clonazione di vcpkg..." -ForegroundColor Yellow
    git clone https://github.com/microsoft/vcpkg.git external\vcpkg
    Push-Location external\vcpkg
    .\bootstrap-vcpkg.bat
    Pop-Location
}

Write-Host "`n== Tutti gli strumenti installati con successo. ==" -ForegroundColor Green