$AwesomeMd = "awesome-hpp.md"
$DepsJson = "deps.json"
$AwesomeUrl = "https://raw.githubusercontent.com/p-ranav/awesome-hpp/master/README.md"

if (-Not (Test-Path $AwesomeMd)) {
    Write-Host "Downloading header-only library list..."
    Invoke-WebRequest -Uri $AwesomeUrl -OutFile $AwesomeMd
}

param (
    [Parameter(Mandatory=$true)]
    [string]$Query
)

$lines = Get-Content $AwesomeMd | Select-String -Pattern '\[.*?\]\(https://github.com/.*?\)' | Where-Object { $_ -match $Query }

if ($lines.Count -eq 0) {
    Write-Host "No matches found for '$Query'"
    exit
}

$results = @()
foreach ($line in $lines) {
    if ($line -match '\[([^\]]+)\]\((https://github.com/[^\)]+)\)') {
        $results += [PSCustomObject]@{
            Name = $matches[1]
            Repo = $matches[2] + ".git"
        }
    }
}

for ($i = 0; $i -lt $results.Count; $i++) {
    Write-Host "[$i] $($results[$i].Name) -> $($results[$i].Repo)"
}

$choice = Read-Host "Select a library number to add to deps.json"
if (-not ($choice -match '^\d+$') -or $choice -ge $results.Count) {
    Write-Error "Invalid selection."
    exit
}

$entry = $results[$choice]

if (-Not (Test-Path $DepsJson)) {
    "[]" | Out-File $DepsJson
}

$deps = Get-Content $DepsJson | ConvertFrom-Json
$deps += [PSCustomObject]@{
    name = $entry.Name
    repo = $entry.Repo
    includes = "include"
}

$deps | ConvertTo-Json -Depth 10 | Out-File $DepsJson -Encoding utf8
Write-Host "✔ Added $($entry.Name) to deps.json"