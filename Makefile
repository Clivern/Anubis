BASH           ?= bash

help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## build: Build My Environment.
build:
	@echo ">> ============= Build My Environment ============= <<"
	$(BASH) ./brew.sh
	$(BASH) ./bin/zsh.sh
	$(BASH) ./bin/composer.sh
	$(BASH) ./bin/pip.sh
	$(BASH) ./bin/pet.sh
	$(BASH) ./bin/doctl.sh
	$(BASH) ./bin/kubectl.sh
	$(BASH) ./bin/terraform.sh
	$(BASH) ./bin/glow.sh
	$(BASH) ./bin/ngrok.sh
	$(BASH) ./bin/rust_cargo.sh
	$(BASH) ./bin/helm.sh
	$(BASH) ./bin/ansible.sh
	$(BASH) ./bin/goreleaser.sh
	$(BASH) ./bin/github.sh
	$(BASH) ./bin/apes.sh
	$(BASH) ./bin/rhino.sh
	$(BASH) ./bin/poodle.sh
	$(BASH) ./bin/npm_pkgs.sh
	$(BASH) ./bin/symfony.sh
	$(BASH) ./bin/laravel.sh
	$(BASH) ./bin/go_pkgs.sh
	$(BASH) ./bin/hugo.sh
	$(BASH) ./bin/fx.sh
	$(BASH) ./bin/vim.sh
	$(BASH) ./env.sh


## sync: Sync My dotfiles.
sync:
	@echo ">> ============= Sync My dotfiles ============= <<"
	$(BASH) bootstrap.sh
	$(BASH) extra.sh


.PHONY: help
