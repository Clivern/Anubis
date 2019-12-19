#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

brew install git
brew install wget --with-iri
brew install fzf

# Install rbenv & ruby 2.6.5
brew install rbenv ruby-build
rbenv install 2.6.5
rbenv global 2.6.5
rbenv local 2.6.5

# Remove outdated versions from the cellar.
brew cleanup
