# dotfiles

My dotfiles and fresh install setup. Uses `ts` to configure a new system so it can be OS agnostic.

## Mac

Pretty straight forward, the installer script should do everything needed. Run `./install_mac/sh`

## Windows

Run `.\install_windows.ps1`.

The only manual step needed after the install script has run is to install the font into settings. To do this

- Go to `Settings -> Personalisation -> Fonts`
- Click `Browse and install fonts`
- Get desired `ttf` font files from `$HOME\scoop\apps\<font>\current`
- Restarting terminals and or vscode should now use the desired fonts.

## TODOs

- Implement a Ubuntu installer
