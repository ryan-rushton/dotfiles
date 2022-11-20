# Get scoop, used to get fonts
if (Test-Path -Path $HOME\scoop) {
    "Scoop is already installed, updating"
    scoop update --all
}
else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    Invoke-RestMethod get.scoop.sh | Invoke-Expression  

    # Install scoop stuffs
    scoop bucket add java
    scoop install sudo
    scoop install temurin11-jdk
    scoop install gradle
}

$installs = @(
    # general
    "AgileBits.1Password",
    "Google.Chrome",
    "Google.Drive",
    # dev
    "CoreyButler.NVMforWindows",
    "Git.Git", 
    "GitHub.cli",
    "JetBrains.Toolbox",
    "Microsoft.VisualStudioCode", 
    "Python.Python.3.10",
    "Starship.Starship",
    # gaming
    "Discord.Discord",
    "EpicGames.EpicGamesLauncher",
    "Logitech.GHUB"
    "Nvidia.GeForceExperience",
    "Ubisoft.Connect",
    "Valve.Steam"
)

# These apps can't update via winget
$dontUpdate = @(
    "Discord.Discord"
)

[string]$alreadyInstalled = winget list

foreach ($install in $installs) {
    if ($alreadyInstalled.Contains($install)) {
        $install + " is already installed"
    }
    elseif ($dontUpdate.Contains($install)) {
        # Do nothing
    }
    else {
        "Installing: " + $install
        winget install -h --accept-package-agreements --accept-source-agreements --id $install
    }
}

winget upgrade --all

if (Test-Path -Path .\nerd-fonts) {
    "Nerd fonts is already installed, updating"
    Set-Location nerd-fonts
    git pull
    .\install.ps1 FiraCode
    Set-Location ..
}
else {
    # Setting up nerd fonts
    git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
    Set-Location nerd-fonts
    git sparse-checkout add patched-fonts/FiraCode
    .\install.ps1 FiraCode
    Set-Location ..    
}

# Install node and yarn classic
sudo nvm install latest
npm i -g yarn

# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 

function addSymlink($path, $target) {
    if (-Not (Test-Path -Path $path)) {
        sudo New-Item -ItemType SymbolicLink -Path $path -Target $target
    }
}

# Make dir for powershell profile
# Powershell 5
mkdir $HOME\Documents\WindowsPowerShell -Force
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -target ".\src\powershell\Microsoft.PowerShell_profile.ps1"
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" -target ".\src\powershell\Microsoft.PowerShell_profile.ps1"

# Powershell 7
mkdir $HOME\Documents\PowerShell -Force
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -target ".\src\powershell\Microsoft.PowerShell_profile.ps1"
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -target ".\src\powershell\Microsoft.PowerShell_profile.ps1"

yarn install

# Setup windows terminal
sudo yarn ts-node ".\src\windows\setup.ts"

# Load profile
. $PROFILE

& $profile
