import { access, constants, rm, stat, symlink, unlink } from "node:fs/promises";

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
  } catch (e) {
    console.error(`Unable to create symlink for ${configPath} with target ${targetPath}.`, e);
  }
}
