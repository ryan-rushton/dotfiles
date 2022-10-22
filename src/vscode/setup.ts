import { execSync } from 'child_process';
import { homedir, platform } from 'os';
import { join } from 'path';
import { createSymlink } from '../utils/utils';

const SETTINGS_FILE_NAME = 'settings.json';

const EXTENSIONS = [
  'dbaeumer.vscode-eslint',
  'eamodio.gitlens',
  'esbenp.prettier-vscode',
  'foxundermoon.shell-format',
  'ms-python.python',
  'Orta.vscode-jest',
  'streetsidesoftware.code-spell-checker',
  'stylelint.vscode-stylelint',
  'tamasfe.even-better-toml',
];

function getSettingsLocation() {
  const home = homedir();
  const system = platform();

  switch (system) {
    case 'darwin':
      return join(home, 'Library', 'Application Support', 'Code', 'User', SETTINGS_FILE_NAME);
    case 'win32':
      return join(home, 'AppData', 'Roaming', 'Code', 'User', SETTINGS_FILE_NAME);
    case 'linux':
      return join(home, '.config', 'Code', 'User', SETTINGS_FILE_NAME);
    default:
      throw new Error(`System ${system} is not supported for vs code file setup`);
  }
}

export async function setup() {
  console.info('Setting up vscode');
  const config = join(__dirname, SETTINGS_FILE_NAME);
  const target = getSettingsLocation();
  await createSymlink(config, target);

  for (const extension of EXTENSIONS) {
    console.info(`Installing vscode extension ${extension}`);
    execSync(`code --install-extension ${extension}`);
  }
}

setup();
