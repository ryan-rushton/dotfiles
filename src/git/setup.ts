import { exec } from 'node:child_process';
import { homedir } from 'node:os';
import path from 'node:path';
import { touch } from '../utils/utils';

/**
 * Sets up git personal git config
 */
export function setup() {
  const home = homedir();
  const gitignoreGlobal = path.join(home, '.gitignore_global');
  console.log(`Creating global gitignore ${gitignoreGlobal}`);

  touch(gitignoreGlobal);

  const configs = {
    'user.email': 'ryan.rushton79@gmail.com',
    'user.name': 'Ryan Rushton',
    'pull.twohead': 'ort',
    'core.editor': 'vim',
    'core.excludesfile': gitignoreGlobal,
  };

  console.log('Setting git config');

  for (const [key, value] of Object.entries(configs)) {
    console.log(`Setting ${key} to ${value}`);
    exec(`git config --global ${key} ${value}`);
  }
}
