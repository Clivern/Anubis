#!/usr/bin/env bash

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".phpintel/" \
		--exclude "zsh/" \
		--exclude "composer/" \
		--exclude "pip/" \
		--exclude "pet/" \
		--exclude "doctl/" \
		--exclude "kubectl/" \
		--exclude "tf_v1.1.9/" \
		--exclude "glow/" \
		--exclude "ngrok/" \
		--exclude "rust_cargo/" \
		--exclude "helm/" \
		--exclude "ansible/" \
		--exclude "goreleaser/" \
		--exclude "github/" \
		--exclude "apes/" \
		--exclude "rhino/" \
		--exclude "poodle/" \
		--exclude "npm_pkgs/" \
		--exclude "symfony/" \
		--exclude "laravel/" \
		--exclude "go_pkgs/" \
		--exclude "hugo/" \
		--exclude "fx/" \
		--exclude "vim/" \
		--exclude "nomad/" \
		--exclude "consul/" \
		--exclude "img/" \
		--exclude "init/" \
		--exclude "dotfiles.fish/" \
		--exclude "iterm/" \
		--exclude "git_cc/" \
		--exclude "fzf/" \
		--exclude "habitat/" \
		--exclude "helidon/" \
		--exclude "kubectx/" \
		--exclude "mvn/" \
		--exclude "php_redis/" \
		--exclude "pushover/" \
		--exclude "revive/" \
		--exclude "svu/" \
		--exclude "tf_v0.13.7/" \
		--exclude "arduino/" \
		--exclude "aws/" \
		--exclude "bazel/" \
		--exclude "bootstrap.sh" \
		--exclude "brew.sh" \
		--exclude "env.sh" \
		--exclude "extra.sh" \
		--exclude "Makefile" \
		--exclude "README.md" \
		--exclude ".gitconfig-personal-space" \
		--exclude ".gitconfig-work-space" \
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
