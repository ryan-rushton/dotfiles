$installs = @(
    # general
    "Google.Chrome",
    "AgileBits.1Password",
    # dev
    "Git.git", 
    "Microsoft.VisualStudioCode", 
    "GitHub.cli",
    "Python.Python.3.10",
    "EclipseAdoptium.Temurin.11.JDK",
    "CoreyButler.NVMforWindows",
    # gaming
    "Valve.Steam",
    "EpicGames.EpicGamesLauncher",
    "Ubisoft.Connect",
    "Nvidia.GeForceExperience",
    "Logitech.GHUB"
)

foreach ($install in $installs) {
    "Installing:" + $install
    winget install -h --accept-package-agreements --accept-source-agreements --id $install
}

# Make dir for powershell profile
# Powershell 5
mkdir $HOME\Documents\WindowsPowerShell -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target ".\powershell\Microsoft.PowerShell_profile.ps1" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1" -Target ".\powershell\Microsoft.PowerShell_profile.ps1" -Force

# Powershell 7
mkdir $HOME\Documents\PowerShell -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target ".\powershell\Microsoft.PowerShell_profile.ps1" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\Microsoft.VSCode_profile.ps1" -Target ".\powershell\Microsoft.PowerShell_profile.ps1" -Force

# Refresh path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

# Load profile
. $PROFILE
