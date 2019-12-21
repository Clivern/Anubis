#!/usr/bin/env bash

git pull origin master;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".phpintel/" \
		--exclude "bin/" \
		--exclude "dmg/" \
		--exclude "img/" \
		--exclude "init/" \
		--exclude "third_party/" \
		--exclude "bootstrap.sh" \
		--exclude ".travis.yml" \
		--exclude "brew.sh" \
		--exclude "env.sh" \
		--exclude "Makefile" \
		--exclude "README.md" \
		-avh --no-perms . ~;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
