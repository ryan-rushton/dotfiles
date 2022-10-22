import { execSync } from 'node:child_process';
import { homedir } from 'node:os';
import path from 'node:path';
import { touch } from '../utils/utils';

/**
 * Sets up git personal git config
 */
async function setup() {
  console.info('Setting up git');
  const home = homedir();
  const gitignoreGlobal = path.join(home, '.gitignore_global');
  console.info(`Creating global gitignore ${gitignoreGlobal}`);

  await touch(gitignoreGlobal);

  const configs = {
    'user.email': 'ryan.rushton79@gmail.com',
    'user.name': 'Ryan Rushton',
    'pull.twohead': 'ort',
    'core.editor': 'vim',
    'core.excludesfile': gitignoreGlobal,
  };

  console.info('Setting git config');

  for (const [key, value] of Object.entries(configs)) {
    console.info(`Setting ${key} to ${value}`);
    execSync(`git config --global ${key} ${value}`);
  }
}

setup();
