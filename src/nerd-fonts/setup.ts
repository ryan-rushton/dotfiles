import { exec } from 'node:child_process';
import { promisify } from 'node:util';

const execAsync = promisify(exec);

/**
 * Installs Nerd Fonts using the recommended platform-specific package managers
 */
export async function setupNerdFonts(): Promise<void> {
  const platform = process.platform;
  
  console.info('Installing Nerd Fonts...');
  
  try {
    switch (platform) {
      case 'darwin':
        await installMacOS();
        break;
      case 'win32':
        await installWindows();
        break;
      case 'linux':
        await installLinux();
        break;
      default:
        console.warn(`Platform ${platform} not supported for automatic Nerd Fonts installation.`);
        console.info('Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases');
    }
  } catch (error) {
    console.error('Failed to install Nerd Fonts:', error);
    console.info('Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases');
  }
}

async function installMacOS(): Promise<void> {
  console.info('Installing FiraCode Nerd Font via Homebrew...');
  await execAsync('brew install font-fira-code-nerd-font');
  console.info('FiraCode Nerd Font installed successfully!');
}

async function installWindows(): Promise<void> {
  console.info('Attempting to install FiraCode Nerd Font via package managers...');
  
  // Try Chocolatey first
  try {
    await execAsync('choco --version');
    console.info('Installing via Chocolatey...');
    await execAsync('choco install nerd-fonts-firacode -y');
    console.info('FiraCode Nerd Font installed via Chocolatey!');
    return;
  } catch {
    console.info('Chocolatey not available, trying Scoop...');
  }
  
  // Try Scoop as fallback
  try {
    await execAsync('scoop --version');
    console.info('Installing via Scoop...');
    await execAsync('scoop bucket add nerd-fonts');
    await execAsync('scoop install FiraCode-NF');
    console.info('FiraCode Nerd Font installed via Scoop!');
    return;
  } catch {
    console.info('Scoop not available, trying PowerShell module...');
  }
  
  // Try PowerShell NerdFonts module as final fallback
  try {
    console.info('Installing via PowerShell NerdFonts module...');
    await execAsync('powershell -Command "Install-PSResource -Name NerdFonts -Force; Import-Module -Name NerdFonts; Install-NerdFont -Name FiraCode"');
    console.info('FiraCode Nerd Font installed via PowerShell module!');
  } catch {
    throw new Error('No suitable package manager found. Please install manually.');
  }
}

async function installLinux(): Promise<void> {
  console.info('Detecting Linux distribution...');
  
  // Check if we're on Arch-based system
  try {
    await execAsync('pacman --version');
    console.info('Installing FiraCode Nerd Font via pacman...');
    await execAsync('sudo pacman -S --noconfirm ttf-firacode-nerd');
    console.info('FiraCode Nerd Font installed via pacman!');
    return;
  } catch {
    // Not Arch, continue to other methods
  }
  
  // Check for apt (Debian/Ubuntu)
  try {
    await execAsync('apt --version');
    console.info('Installing FiraCode Nerd Font via apt...');
    
    // First try the fonts-firacode package which might include nerd font variants
    try {
      await execAsync('sudo apt update && sudo apt install -y fonts-firacode');
      console.info('FiraCode font installed via apt. Note: This may not be the Nerd Font version.');
      console.info('For the full Nerd Font version, please download from: https://github.com/ryanoasis/nerd-fonts/releases');
    } catch {
      throw new Error('Failed to install via apt');
    }
    return;
  } catch {
    // Not Debian/Ubuntu, continue
  }
  
  // Check for dnf (Fedora)
  try {
    await execAsync('dnf --version');
    console.info('Installing FiraCode Nerd Font via dnf...');
    await execAsync('sudo dnf install -y fira-code-fonts');
    console.info('FiraCode font installed via dnf. Note: This may not be the Nerd Font version.');
    console.info('For the full Nerd Font version, please download from: https://github.com/ryanoasis/nerd-fonts/releases');
    return;
  } catch {
    // Not Fedora, continue
  }
  
  // Fallback to manual download
  console.warn('Could not detect a supported package manager.');
  console.info('Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases');
  console.info('Download the FiraCode.zip file and install the fonts according to your distribution instructions.');
}