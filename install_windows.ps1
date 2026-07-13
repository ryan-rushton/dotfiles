# Self-bootstrapping for online execution (e.g. via irm | iex)
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { "." }
$hasRepoFiles = (Test-Path "$scriptDir\config\powershell\Microsoft.PowerShell_profile.ps1") -and (Test-Path "$scriptDir\src\main.py")

if (-not $hasRepoFiles) {
    Write-Host "Running in standalone/online mode. Downloading full dotfiles repository..."
    $dest = "$HOME\Dev\dotfiles"
    
    $zipPath = "$env:TEMP\dotfiles.zip"
    $tempExtract = "$env:TEMP\dotfiles-temp"
    
    Write-Host "Downloading repository ZIP from GitHub..."
    Invoke-RestMethod -Uri "https://github.com/ryan-rushton/dotfiles/archive/refs/heads/main.zip" -OutFile $zipPath
    
    Write-Host "Extracting repository..."
    if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force }
    Expand-Archive -Path $zipPath -DestinationPath $tempExtract -Force
    
    Write-Host "Setting up target directory at $dest..."
    if (Test-Path $dest) {
        Write-Warning "Target directory $dest already exists. Replacing it..."
        Remove-Item $dest -Recurse -Force
    }
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    Move-Item -Path "$tempExtract\dotfiles-main" -Destination $dest -Force
    
    Remove-Item -Path $zipPath -Force
    
    Write-Host "Repository downloaded successfully to $dest!"
    Write-Host "Restarting installer from $dest..."
    
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    cd $dest
    & "$dest\install_windows.ps1"
    return
}

# Function to install Scoop package manager
function Install-Scoop {
    Write-Host "Setting up Scoop package manager..."
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Scoop is already installed, updating..."
        scoop update --all
    }
    else {
        Write-Host "Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
        # Refresh current session path so scoop commands are immediately available
        Update-EnvironmentPath
        scoop bucket add java
        scoop install sudo
    }
}

# Function to install applications via Winget
function Install-Applications {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warning "winget (Windows Package Manager) was not found. Skipping Winget installations."
        return
    }
    
    Write-Host "Installing applications via Winget..."
    
    # Core applications to install
    $generalApps = @(
        "AgileBits.1Password",
        "Google.Chrome",
        "Google.Drive"
    )
    
    # Development tools
    $devTools = @(
        "CoreyButler.NVMforWindows",
        "Git.Git",
        "GitHub.cli",
        "Microsoft.Powershell",
        "Microsoft.VisualStudio.2022.BuildTools",
        "Microsoft.VisualStudioCode",
        "EclipseAdoptium.Temurin.25.JDK",
        "Python.Python.3.14",
        "Rustlang.Rustup",
        "Starship.Starship"
    )
    
    # Gaming applications
    $gamingApps = @(
        "Discord.Discord",
        "EpicGames.EpicGamesLauncher",
        "Logitech.GHUB",
        "Nvidia.GeForceExperience",
        "Ubisoft.Connect",
        "Valve.Steam"
    )
    
    # Combine all applications
    $allApps = $generalApps + $devTools + $gamingApps
    
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
    
    # Install each application
    foreach ($app in $allApps) {
        Install-WingetApp -AppId $app -DontUpdate $dontUpdate -ExecuteOnInstall $executeOnInstall
    }
}

# Function to install a single Winget application
function Install-WingetApp {
    param(
        [string]$AppId,
        [array]$DontUpdate,
        [array]$ExecuteOnInstall
    )
    
    if (winget list --id $AppId 2>$null) {
        if (-Not $DontUpdate.Contains($AppId)) {
            Write-Host "$AppId is already installed, upgrading..."
            winget upgrade -h --id $AppId --silent --accept-package-agreements --accept-source-agreements
        }
        else {
            Write-Host "$AppId is already installed (skipping update)."
        }
    }
    elseif ($ExecuteOnInstall.Contains($AppId)) {
        Write-Host "Installing (with special execution): $AppId"
        winget install -e -h --id $AppId --silent --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Host "Installing: $AppId"
        winget install -h --id $AppId --silent --accept-package-agreements --accept-source-agreements
    }
}


# Function to install Python package manager (uv)
function Install-UV {
    Write-Host "Installing uv (Python package manager)..."
    if (-Not (Get-Command uv -ErrorAction SilentlyContinue)) {
        powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
    }
    else {
        Write-Host "uv is already installed."
    }
}

# Function to install Nerd Fonts
function Install-NerdFonts {
    Write-Host "Installing Nerd Fonts via Scoop..."
    
    if (-Not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Scoop not found. Cannot install Nerd Fonts."
        return
    }
    
    try {
        # Add nerd-fonts bucket (only if not already added)
        $buckets = scoop bucket list
        if ($buckets -notcontains "nerd-fonts") {
            Write-Host "Adding nerd-fonts bucket to Scoop..."
            scoop bucket add nerd-fonts
        } else {
            Write-Host "Nerd-fonts bucket already exists."
        }
        
        # Check if FiraCode-NF is already installed
        $installed = scoop list FiraCode-NF 2>$null
        if ($installed) {
            Write-Host "FiraCode Nerd Font is already installed, checking for updates..."
            scoop update FiraCode-NF
            Write-Host "✅ FiraCode Nerd Font updated successfully!"
        } else {
            Write-Host "Installing FiraCode Nerd Font..."
            scoop install FiraCode-NF
            Write-Host "✅ FiraCode Nerd Font installed successfully via Scoop!"
        }
    } catch {
        Write-Host "❌ Scoop installation failed. Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases"
    }
}

# Function to refresh environment PATH
function Update-EnvironmentPath {
    Write-Host "Refreshing environment PATH..."
    
    # Add VSCode to PATH if not already present
    $vscodePath = "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\bin"
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    if ((Test-Path $vscodePath) -and ($userPath -notlike "*$vscodePath*")) {
        Write-Host "Adding VSCode to PATH..."
        $userPath = $userPath + ";" + $vscodePath
        [System.Environment]::SetEnvironmentVariable("Path", $userPath, "User")
    }
    
    # Refresh current session PATH from registry
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $env:Path = $machinePath + ";" + $userPath

    # Explicitly append common installer paths to current session PATH if they exist but aren't in registry yet
    $scoopShimPath = "$HOME\scoop\shims"
    if ((Test-Path $scoopShimPath) -and ($env:Path -notlike "*$scoopShimPath*")) {
        $env:Path += ";$scoopShimPath"
    }
    
    $uvBinPath = "$HOME\.local\bin"
    if ((Test-Path $uvBinPath) -and ($env:Path -notlike "*$uvBinPath*")) {
        $env:Path += ";$uvBinPath"
    }

    $nvmPath = "${env:APPDATA}\nvm"
    if ((Test-Path $nvmPath) -and ($env:Path -notlike "*$nvmPath*")) {
        $env:Path += ";$nvmPath"
    }

    # Refresh NVM environment variables in current session
    $nvmHome = [System.Environment]::GetEnvironmentVariable("NVM_HOME", "User")
    if ($nvmHome) {
        $env:NVM_HOME = $nvmHome
    } elseif (Test-Path $nvmPath) {
        $env:NVM_HOME = $nvmPath
    }
    
    $nvmSymlink = [System.Environment]::GetEnvironmentVariable("NVM_SYMLINK", "User")
    if ($nvmSymlink) {
        $env:NVM_SYMLINK = $nvmSymlink
    } elseif (Test-Path $nvmPath) {
        $env:NVM_SYMLINK = "${env:ProgramFiles}\nodejs"
    }
}

# Function to Create Symlinks
function Add-Symlink {
    param(
        [string]$Path,
        [string]$Target
    )
    
    if (-Not (Test-Path -Path $Path) -And (Test-Path -Path $Target)) {
        Write-Host "Creating symlink: $Path -> $Target"
        
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if ($isAdmin) {
            New-Item -ItemType SymbolicLink -Path $Path -Value $Target -Force
        }
        elseif (Get-Command sudo -ErrorAction SilentlyContinue) {
            sudo New-Item -ItemType SymbolicLink -Path $Path -Value $Target -Force
        }
        else {
            Write-Error "Administrator privileges are required to create symbolic links. Please run PowerShell as Administrator."
        }
    }
    elseif (Test-Path -Path $Path) {
        Write-Host "Symlink already exists: $Path"
    }
    else {
        Write-Host "Target does not exist: $Target"
    }
}

# Function to setup PowerShell profiles
function Setup-PowerShellProfiles {
    Write-Host "Setting up PowerShell profiles..."
    
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { "." }
    $profileSource = (Get-Item "$scriptDir\config\powershell\Microsoft.PowerShell_profile.ps1").FullName
    
    # Windows PowerShell (5.1)
    $windowsPSDir = "$HOME\Documents\WindowsPowerShell"
    mkdir $windowsPSDir -Force | Out-Null
    Add-Symlink -Path "$windowsPSDir\Microsoft.PowerShell_profile.ps1" -Target $profileSource
    Add-Symlink -Path "$windowsPSDir\Microsoft.VSCode_profile.ps1" -Target $profileSource
    
    # PowerShell Core (7+)
    $corePSDir = "$HOME\Documents\PowerShell"
    mkdir $corePSDir -Force | Out-Null
    Add-Symlink -Path "$corePSDir\Microsoft.PowerShell_profile.ps1" -Target $profileSource
    Add-Symlink -Path "$corePSDir\Microsoft.VSCode_profile.ps1" -Target $profileSource
}

# Function to install Node.js via NVM
function Install-Node {
    Write-Host "Installing and configuring Node.js..."
    
    # Install and Use Latest LTS Node.js
    if (Get-Command nvm -ErrorAction SilentlyContinue) {
        # Check if already elevated; if so, run without sudo
        $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if ($isAdmin) {
            nvm install lts
            nvm use lts
        }
        else {
            sudo nvm install lts
            nvm use lts
        }
    }
    else {
        Write-Host "NVM not found. Install CoreyButler.NVMforWindows first."
    }
}

# Function to setup dotfiles configuration
function Setup-Dotfiles {
    Write-Host "Running dotfiles configuration..."
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { "." }
    Push-Location $scriptDir
    uv run src/main.py
    Pop-Location
}

# Function to load PowerShell profile
function Load-PowerShellProfile {
    Write-Host "Loading PowerShell profile..."
    if (Test-Path $PROFILE) {
        . $PROFILE
    }
}

# Main installation function
function Start-WindowsInstall {
    # Check if running as Admin at the start
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "This script is not running as Administrator. Some installations and configurations (like NVM, build tools, or symlinks) may fail or prompt for elevation."
        Write-Host "It is highly recommended to run this script in an Administrator PowerShell session."
        Write-Host "Press any key to continue anyway, or Ctrl+C to cancel..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }

    Install-Scoop
    Install-Applications
    
    # Refresh PATH after package installations so NVM, git, etc. are available
    Update-EnvironmentPath
    
    Install-UV
    
    # Refresh PATH again to pick up uv
    Update-EnvironmentPath
    
    Install-Node
    Install-NerdFonts
    Setup-PowerShellProfiles
    Setup-Dotfiles
    Load-PowerShellProfile
    
    Write-Host "Windows dotfiles installation completed! Please restart your terminal."
}

# Run the main installation
Start-WindowsInstall
