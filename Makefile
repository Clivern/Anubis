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
	$(BASH) ./zsh/install.sh
	$(BASH) ./composer/install.sh
	$(BASH) ./pip/install.sh
	$(BASH) ./pet/install.sh
	$(BASH) ./doctl/install.sh
	$(BASH) ./kubectl/install.sh
	$(BASH) ./tf_v1.1.9/install.sh
	$(BASH) ./glow/install.sh
	$(BASH) ./ngrok/install.sh
	$(BASH) ./rust_cargo/install.sh
	$(BASH) ./helm/install.sh
	$(BASH) ./ansible/install.sh
	$(BASH) ./goreleaser/install.sh
	$(BASH) ./github/install.sh
	$(BASH) ./apes/install.sh
	$(BASH) ./rhino/install.sh
	$(BASH) ./poodle/install.sh
	$(BASH) ./npm_pkgs/install.sh
	$(BASH) ./symfony/install.sh
	$(BASH) ./laravel/install.sh
	$(BASH) ./go_pkgs/install.sh
	$(BASH) ./hugo/install.sh
	$(BASH) ./fx/install.sh
	$(BASH) ./vim/install.sh
	$(BASH) ./nomad/install.sh
	$(BASH) ./consul/install.sh
	$(BASH) ./env.sh


## sync: Sync My dotfiles.
sync:
	@echo ">> ============= Sync My dotfiles ============= <<"
	$(BASH) bootstrap.sh
	$(BASH) extra.sh


.PHONY: help
