import { execSync } from 'node:child_process';

/**
 * Sets up mouse and peripheral configuration for Pop OS
 * Configures mouse speed and other peripheral settings
 */
async function setup() {
  console.info('Setting up mouse and peripheral configuration');

  try {
    // Configure mouse speed (default is 0, range is -1 to 1)
    // -0.3 is a good conservative reduction for fast mice
    const mouseSpeed = -0.3;
    console.info(`Setting mouse speed to ${mouseSpeed}...`);
    execSync(`gsettings set org.gnome.desktop.peripherals.mouse speed ${mouseSpeed}`);

    // Configure mouse acceleration profile
    // Options: 'default', 'flat', 'adaptive'
    // 'flat' provides more consistent gaming experience
    console.info('Setting mouse acceleration profile to flat...');
    execSync("gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'");

    // Disable natural scrolling if enabled (traditional scroll direction)
    console.info('Setting traditional scroll direction...');
    execSync('gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false');

    // Set double-click timing (in milliseconds, default is 400)
    console.info('Setting double-click timing...');
    execSync('gsettings set org.gnome.desktop.peripherals.mouse double-click 350');

    console.info('Mouse configuration complete!');
  } catch (error) {
    console.error('Error setting up mouse configuration:', error);
    console.info('You can manually adjust mouse settings in Settings > Mouse & Touchpad');
  }
}

setup();
