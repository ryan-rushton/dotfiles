import { homedir } from 'os'
import { join } from 'path'
import { createSymlink, mkdir } from '../utils/utils'

const CONFIG_FILE = 'starship.toml'

async function setup () {
  console.info('Setting up starship')
  const home = homedir()
  const dotConfig = join(home, '.config')
  await mkdir(dotConfig)

  const target = join(dotConfig, CONFIG_FILE)
  const config = join(__dirname, CONFIG_FILE)

  await createSymlink(config, target)
}

setup()
