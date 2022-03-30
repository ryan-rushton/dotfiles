#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

########
# Dock #
########

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Trackpad/mouse

defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

##########
# Finder #
##########

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# TODO this isn't working
# Show the ~/Library folder
# chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

###################
# Mission control #
###################

# Don't rearrage spaces by last used
defaults write com.apple.dock "mru-spaces" -bool "false"

#################
# Google Chrome #
#################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

killall "Dock"
killall "Finder"
osascript -e 'quit app "Google Chrome"'
osascript -e 'quit app "Visual Studio Code"'
