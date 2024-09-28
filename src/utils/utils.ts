import { access, constants, mkdir as fsMkdir, open, rm, symlink, utimes } from 'node:fs/promises';

/**
 * Creates a symlink and will remove any existing symlink or file.
 *
 * @param configPath The path of the config to be symlinked
 * @param targetPath The symlink path that points back to configPath
 */
export async function createSymlink(configPath: string, symlinkPath: string) {
  try {
    await rm(symlinkPath, { force: true });
    console.info(`Removed existing file ${symlinkPath}`);
  } catch (e: unknown) {
    console.info(`${symlinkPath} doesn't currently exist, creating new.`, e);
  }

  try {
    console.info(`Creating symlink, ${symlinkPath} is linked to ${configPath}.`);
    await rm(symlinkPath, { force: true, recursive: true });
    await symlink(configPath, symlinkPath);
  } catch (e: unknown) {
    console.error(`Unable to create symlink for ${configPath} with symlink ${symlinkPath}.`, e);
  }
}

/**
 * A system agnostic touch function
 *
 * @param path The path to touch
 */
export async function touch(path: string) {
  try {
    const now = Date.now();
    await access(path, constants.R_OK | constants.W_OK);
    // File exists so update the timestamps
    await utimes(path, now, now);
  } catch (e: unknown) {
    // File doesn't exist so create it
    console.info(`Creating file ${path}`);
    await open(path, 'a+');
  }
}

/**
 * Recursive creates a directory for the provided path. If it already exists
 * this is essentially a no-op.
 *
 * @param path Directory path to be created
 */
export async function mkdir(path: string) {
  const created = await fsMkdir(path, { recursive: true });
  if (created) {
    console.info(`Created dir ${created}`);
  }
}
