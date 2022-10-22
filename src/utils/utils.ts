import {
  access,
  constants,
  mkdir as fsMkdir,
  open,
  rm,
  stat,
  symlink,
  unlink,
  utimes,
} from 'node:fs/promises';

/**
 * Creates a symlink and will remove any existing symlink or file.
 *
 * @param configPath The path of the config to be symlinked
 * @param targetPath The symlink path that points back to configPath
 */
export async function createSymlink(configPath: string, targetPath: string) {
  try {
    await access(targetPath, constants.R_OK | constants.W_OK);
    const stats = await stat(targetPath);

    if (stats.isSymbolicLink()) {
      await unlink(targetPath);
      console.log(`Removing existing symlink ${targetPath}`);
    } else if (stats.isFile()) {
      console.log(`Removing existing file ${targetPath}`);
      await rm(targetPath);
    }

    await symlink(configPath, targetPath);
  } catch (e: unknown) {
    console.error(`Unable to create symlink for ${configPath} with target ${targetPath}.`, e);
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
    await open(path, 'a+', 'r+');
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
  console.log(`Created dir ${created}`);
}
