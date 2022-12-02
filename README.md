# dotfiles

My dotfiles and fresh install setup. Uses `ts` to configure a new system so it can be OS agnostic.

## Mac

Pretty straight forward, the installer script should do everything needed. Run `./install_mac.sh`

## Windows

Run `.\install_windows.ps1`.

The only manual step needed after the install script has run is to install the font into settings. There is an installer script that comes with the fonts but it doesn't have the desired result.

- Go to `Settings -> Personalisation -> Fonts`
- Click `Browse and install fonts`
- Get desired `ttf` font files from the `nerd-fonts` repo that was cloned inside this. The windows compatible fonts for Normal and Retina should be enough.
- Restarting terminals and or vscode should now use the desired fonts.

## Ubuntu

Run `./install_ubuntu.sh`
