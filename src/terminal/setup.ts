import { execSync } from 'node:child_process';
import { homedir } from 'node:os';
import { join } from 'node:path';
import { createSymlink, mkdir } from '../utils/utils';

/**
 * Sets up terminal configuration for Pop OS
 * Includes GNOME Terminal keybindings and Alacritty config for better Ctrl+V/P support
 */
async function setup() {
  console.info('Setting up terminal configuration for Pop OS');

  try {
    // Setup GNOME Terminal keybindings (fallback/default)
    console.info('Configuring GNOME Terminal keybindings...');
    execSync('gsettings set org.gnome.Terminal.Legacy.Settings shortcuts-enabled true');

    try {
      // Get the default profile UUID for keybindings
      const defaultProfile = execSync('gsettings get org.gnome.Terminal.ProfilesList default')
        .toString()
        .trim()
        .replace(/'/g, '');

      const profilePath = `/org/gnome/terminal/legacy/profiles:/:${defaultProfile}/`;

      // Set keybindings for the default profile
      execSync(`dconf write ${profilePath}copy-binding "'<Primary><Shift>c'"`);
      execSync(`dconf write ${profilePath}paste-binding "'<Primary><Shift>v'"`);

      console.info(`Configured keybindings for profile: ${defaultProfile}`);
    } catch (terminalError) {
      console.warn(
        'Could not configure GNOME Terminal keybindings (this is expected if using a different terminal)',
        terminalError,
      );
    }

    // Setup Alacritty configuration for better keybinding support
    console.info('Setting up Alacritty configuration...');
    const home = homedir();
    const alacrittyConfigDir = join(home, '.config', 'alacritty');
    await mkdir(alacrittyConfigDir);

    const alacrittyConfigSource = join(__dirname, 'alacritty.yml');
    const alacrittyConfigTarget = join(alacrittyConfigDir, 'alacritty.yml');

    await createSymlink(alacrittyConfigSource, alacrittyConfigTarget);
  } catch (error) {
    console.error('Error setting up terminal configuration:', error);
  }
}

setup();
