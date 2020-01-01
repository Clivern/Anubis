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
	$(BASH) ./third_party/zsh.sh
	$(BASH) ./third_party/composer.sh
	$(BASH) ./third_party/pip.sh
	$(BASH) ./third_party/pet.sh
	$(BASH) ./third_party/doctl.sh
	$(BASH) ./third_party/kubectl.sh
	$(BASH) ./third_party/terraform.sh
	$(BASH) ./third_party/glow.sh
	$(BASH) ./third_party/ngrok.sh
	$(BASH) ./third_party/rust_cargo.sh
	$(BASH) ./env.sh


## sync: Sync My dotfiles.
sync:
	@echo ">> ============= Sync My dotfiles ============= <<"
	$(BASH) bootstrap.sh


.PHONY: help
