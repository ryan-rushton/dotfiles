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
        scoop bucket add java
        scoop install sudo gradle
    }
}

# Function to install applications via Winget
function Install-Applications {
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
        "JetBrains.Toolbox",
        "Microsoft.Powershell",
        "Microsoft.VisualStudio.2022.BuildTools",
        "Microsoft.VisualStudioCode", 
        "EclipseAdoptium.Temurin.21.JDK",
        "Python.Python.3.13",
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
        } else {
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

# Function to install Node.js via NVM
function Install-Node {
    Write-Host "Installing and configuring Node.js..."
    
    # Install and Use Latest LTS Node.js
    if (Get-Command nvm -ErrorAction SilentlyContinue) {
        sudo nvm install lts
        nvm use lts
    } else {
        Write-Host "NVM not found. Install CoreyButler.NVMforWindows first."
    }
}

# Function to install Python package manager (uv)
function Install-UV {
    Write-Host "Installing uv (Python package manager)..."
    if (-Not (Get-Command uv -ErrorAction SilentlyContinue)) {
        powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
    } else {
        Write-Host "uv is already installed."
    }
}

# Function to install Nerd Fonts
function Install-NerdFonts {
    Write-Host "Installing Nerd Fonts via TypeScript module..."
    npx ts-node ".\src\nerd-fonts\setup.ts"
}

# Function to refresh environment PATH
function Update-EnvironmentPath {
    Write-Host "Refreshing environment PATH..."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
        [System.Environment]::GetEnvironmentVariable("Path", "User")
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path, "User")
}

# Function to Create Symlinks
function Add-Symlink {
    param(
        [string]$Path,
        [string]$Target
    )
    
    if (-Not (Test-Path -Path $Path) -And (Test-Path -Path $Target)) {
        Write-Host "Creating symlink: $Path -> $Target"
        sudo New-Item -ItemType SymbolicLink -Path $Path -Value $Target -Force
    } elseif (Test-Path -Path $Path) {
        Write-Host "Symlink already exists: $Path"
    } else {
        Write-Host "Target does not exist: $Target"
    }
}

# Function to setup PowerShell profiles
function Setup-PowerShellProfiles {
    Write-Host "Setting up PowerShell profiles..."
    
    $profileSource = (Get-Item ".\src\powershell\Microsoft.PowerShell_profile.ps1").FullName
    
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

# Function to setup dotfiles configuration
function Setup-Dotfiles {
    Write-Host "Setting up dotfiles configuration..."
    
    # Install project dependencies if needed
    if (-Not (Test-Path "node_modules")) {
        Write-Host "Installing npm dependencies..."
        npm install
    }
    
    # Choose implementation based on environment variable (default to Python)
    if ($env:USE_PYTHON -eq "false") {
        Write-Host "Using TypeScript implementation..."
        # Install Windows Terminal Settings
        npm install -g ts-node
        sudo npx ts-node ".\src\windows\setup.ts"
    } else {
        Write-Host "Using Python implementation..."
        uv run setup/main.py --module windows
    }
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
    Install-Scoop
    Install-Applications
    Install-Node
    Install-UV
    Install-NerdFonts
    Update-EnvironmentPath
    Setup-PowerShellProfiles
    Setup-Dotfiles
    Load-PowerShellProfile
    
    Write-Host "Windows dotfiles installation completed! Please restart your terminal."
}

# Run the main installation
Start-WindowsInstall
