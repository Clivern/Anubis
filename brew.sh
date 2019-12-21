#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

brew install git
brew install wget
brew install curl
brew install fzf
brew install go
brew install python@3.8
brew install php@7.3
brew cask info java
brew cask install java
brew install gradle

# Install rbenv & ruby 2.6.5
brew install rbenv ruby-build
rbenv install 2.6.5
rbenv global 2.6.5
rbenv local 2.6.5

# Remove outdated versions from the cellar.
brew cleanup
