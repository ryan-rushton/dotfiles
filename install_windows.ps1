# Ensure Scoop is Installed
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop is already installed, updating..."
    scoop update --all
}
else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression  
    scoop bucket add java
    scoop install sudo temurin11-jdk gradle
}

# Applications to Install via Winget
$installs = @(
    # General
    "AgileBits.1Password",
    "Google.Chrome",
    "Google.Drive",
    # Dev Tools
    "CoreyButler.NVMforWindows",
    "Git.Git", 
    "GitHub.cli",
    "JetBrains.Toolbox",
    "Microsoft.Powershell",
    "Microsoft.VisualStudio.2022.BuildTools",
    "Microsoft.VisualStudioCode", 
    "Python.Python.3.13",
    "Rustlang.Rustup",
    "Starship.Starship",
    # Gaming
    "Discord.Discord",
    "EpicGames.EpicGamesLauncher",
    "Logitech.GHUB",
    "Nvidia.GeForceExperience",
    "Ubisoft.Connect",
    "Valve.Steam"
)

# Applications that Cannot Be Updated via Winget
$dontUpdate = @(
    "Discord.Discord",
    "Rustlang.Rustup"
)

# Applications that Require Execution on Install
$executeOnInstall = @(
    "Microsoft.VisualStudio.2022.BuildTools",
    "Rustlang.Rustup"
)

# Install or Upgrade Applications via Winget
foreach ($install in $installs) {
    if (winget list --id $install) {
        if (-Not $dontUpdate.Contains($install)) {
            Write-Host "$install is already installed, upgrading..."
            winget upgrade -h --id $install --silent --accept-package-agreements --accept-source-agreements
        }
    }
    elseif ($executeOnInstall.Contains($install)) {
        Write-Host "Installing (with special execution): $install"
        winget install -e -h --id $install --silent --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Host "Installing: $install"
        winget install -h --id $install --silent --accept-package-agreements --accept-source-agreements
    }
}

$originalPath = Get-Location

# Nerd Fonts Installation
$nerdFontsPath = "$HOME\nerd-fonts"
if (Test-Path -Path $nerdFontsPath) {
    Write-Host "Nerd fonts is already installed, updating..."
    Set-Location $nerdFontsPath
    git pull
    Set-Location $originalPath
}
else {
    Write-Host "Installing Nerd Fonts..."
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git $nerdFontsPath
    Set-Location $nerdFontsPath
    git sparse-checkout add patched-fonts/FiraCode
    Set-Location $originalPath
}

# Install and Use Latest Node.js
sudo nvm install latest
nvm use latest

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
    [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, "User")

# Function to Create Symlinks
function addSymlink($path, $target) {
    if (-Not (Test-Path -Path $path) -And (Test-Path -Path $target)) {
        sudo New-Item -ItemType SymbolicLink -Path $path -Value $target -Force
    }
}

# Set Up PowerShell Profiles
mkdir $HOME\Documents\WindowsPowerShell -Force
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -target (Get-Item ".\src\powershell\Microsoft.PowerShell_profile.ps1").FullName
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" -target (Get-Item ".\src\powershell\Microsoft.PowerShell_profile.ps1").FullName

mkdir $HOME\Documents\PowerShell -Force
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -target (Get-Item ".\src\powershell\Microsoft.PowerShell_profile.ps1").FullName
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -target (Get-Item ".\src\powershell\Microsoft.PowerShell_profile.ps1").FullName

# Install Windows Terminal Settings
npm install -g ts-node
sudo npx ts-node ".\src\windows\setup.ts"

# Load PowerShell Profile
. $PROFILE
& $profile
