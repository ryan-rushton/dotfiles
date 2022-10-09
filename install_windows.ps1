# Get scoop, used to get fonts
if (Test-Path -Path $HOME\scoop) {
    "Scoop is already installed"
}
else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    Invoke-RestMethod get.scoop.sh | Invoke-Expression  
}


scoop bucket add nerd-fonts
scoop install FiraCode
scoop install FiraCode-NF
scoop install FiraCode-NF-Mono
scoop install sudo

$installs = @(
    # general
    "Google.Chrome",
    "AgileBits.1Password",
    # dev
    "Git.Git", 
    "Microsoft.VisualStudioCode", 
    "GitHub.cli",
    "Python.Python.3.10",
    "EclipseAdoptium.Temurin.11.JDK",
    "CoreyButler.NVMforWindows",
    "JetBrains.Toolbox",
    "Starship.Starship",
    # gaming
    "Valve.Steam",
    "EpicGames.EpicGamesLauncher",
    "Ubisoft.Connect",
    "Nvidia.GeForceExperience",
    "Logitech.GHUB"
)

[string]$alreadyInstalled = winget list

foreach ($install in $installs) {
    if ($alreadyInstalled.Contains($install)) {
        $install + " is already installed"
    }
    else {
        "Installing: " + $install
        winget install -h --accept-package-agreements --accept-source-agreements --id $install
    }
}

winget upgrade --all

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
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -target ".\powershell\Microsoft.PowerShell_profile.ps1"
addSymlink -path "$HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" -target ".\powershell\Microsoft.PowerShell_profile.ps1"

# Powershell 7
mkdir $HOME\Documents\PowerShell -Force
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -target ".\powershell\Microsoft.PowerShell_profile.ps1"
addSymlink -path "$HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -target ".\powershell\Microsoft.PowerShell_profile.ps1"

# Setup starship config
sudo python -m "starship.setup"

# Load profile
. $PROFILE

# Setup git config
python -m "git.setup"

# Setup vs code
sudo python -m "vscode.setup"
