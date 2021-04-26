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
brew install screen
brew install tmux
brew install go
brew install python@3.9
brew install php@7.3
brew install httpie
brew install watch
brew install wget
brew install ttyrec
brew install yarn
brew install groovy
brew install tree
brew install warrensbox/tap/tfswitch
brew install task

# java
brew install java --cask

# google-chrome
brew install google-chrome --cask

# sublime-text
brew install sublime-text --cask

# iterm2
brew install iterm2 --cask

# visual-studio-code
brew install visual-studio-code --cask

brew install --cask wireshark

# ccleaner
brew install ccleaner --cask

# https://gpgtools.org/
brew install gpg-suite --cask

# postico (free trial)
brew install --cask postico

# gradle
brew install gradle

# Node & Npm
brew install node

# elixir lang
brew install elixir

# asciinema
brew install asciinema

# MySQL
brew install mysql@5.7

# git-crypt
brew install git-crypt

# ack
brew install ack

# Install rbenv & ruby 3.1.0
brew install rbenv ruby-build
# rbenv install 3.1.0
rbenv install 3.1.0
rbenv global 3.1.0
rbenv local 3.1.0
gem install rails -v 6.1.3
gem install bundler jekyll

brew install kubectx

brew install virtualbox --cask

brew install vagrant --cask

brew install buildpacks/tap/pack

brew install mysql-client

# Remove outdated versions from the cellar.
brew cleanup
