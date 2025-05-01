Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Output "Installing required tools..."

# 1. Verifica Git e MSVC
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git not found. Please install Git manually."
    exit 1
}

if (-not (Get-Command cl -ErrorAction SilentlyContinue)) {
    Write-Error "MSVC (cl.exe) compiler not found. Please install Visual Studio with C++ workloads."
    exit 1
}

# 2. Installa Scoop se mancante
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
}

# 3. Aggiunge gli shims di Scoop alla sessione
$ScoopShims = "$env:USERPROFILE\scoop\shims"
if (-not ($env:PATH -split ";" | Where-Object { $_ -eq $ScoopShims })) {
    Write-Output "Adding Scoop shims to PATH..."
    $env:PATH = "$ScoopShims;$env:PATH"
}

# 4. Installa Ninja
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Ninja via Scoop..."
    scoop install ninja
}
if (-not (Get-Command ninja -ErrorAction SilentlyContinue)) {
    Write-Error "Ninja is not available on PATH after installation."
    exit 1
}

# 5. Installa Premake5
$PremakeBin = "$env:USERPROFILE\scoop\apps\premake\current\premake5.exe"
$LocalBin = "$env:USERPROFILE\.local\bin"

if (-not (Get-Command premake5 -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Premake5 via Scoop..."
    scoop install premake
}

# Se non disponibile nel PATH, copialo a .local/bin e aggiorna PATH
if (-not (Get-Command premake5 -ErrorAction SilentlyContinue)) {
    if (Test-Path $PremakeBin) {
        Write-Output "Copying premake5.exe to $LocalBin"
        New-Item -ItemType Directory -Force -Path $LocalBin | Out-Null
        Copy-Item $PremakeBin "$LocalBin\premake5.exe" -Force
        $env:PATH = "$LocalBin;$env:PATH"

        if ($env:GITHUB_PATH) {
            Add-Content -Path $env:GITHUB_PATH -Value $LocalBin
        }
    } else {
        Write-Error "Premake5 binary not found after installation."
        exit 1
    }
}

# 6. Clona premake-ninja
if (-not (Test-Path "external\premake-ninja")) {
    Write-Output "Cloning premake-ninja module..."
    git clone https://github.com/jimon/premake-ninja.git external\premake-ninja
}

# 7. Clona vcpkg
if (-not (Test-Path "external\vcpkg")) {
    Write-Output "Cloning vcpkg repository..."
    git clone https://github.com/microsoft/vcpkg.git external\vcpkg
    Push-Location external\vcpkg
    .\bootstrap-vcpkg.bat
    Pop-Location
}

# 8. Verifica finale
Write-Output "Verifying Premake5 installation..."
try {
    premake5 --version
    Write-Output "Premake5 is correctly installed and available in PATH."
} catch {
    Write-Error "Premake5 installation failed: command not found or not working."
    exit 1
}