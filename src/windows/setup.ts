import { join } from 'path';
import { createSymlink } from '../utils/utils';
// Since this is a helper file for windows these imports setup all the generic setup files when they are imported
import '../git/setup';
import '../starship/setup';
import '../vscode/setup';

const SETTINGS_FILE = 'settings.json';

async function setupWindowsTerminal() {
  console.info('Setting up windows terminal');
  const localAppData = process.env.LOCALAPPDATA;

  if (!localAppData) {
    console.warn(
      'Cannot install windows terminal settings because LOCALAPPDATA cannot be resolved.',
    );
    return;
  }

  // Target comes from https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file
  const target = join(
    localAppData,
    'Packages',
    'Microsoft.WindowsTerminal_8wekyb3d8bbwe',
    'LocalState',
    'settings.json',
  );
  const config = join(__dirname, SETTINGS_FILE);

  await createSymlink(config, target);
}

setupWindowsTerminal();
