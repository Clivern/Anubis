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
	$(BASH) ./third_party/go.sh
	$(BASH) ./third_party/php.sh
	$(BASH) ./third_party/python.sh
	$(BASH) ./third_party/java.sh
	$(BASH) ./third_party/pet.sh
	$(BASH) ./third_party/zsh.sh
	$(BASH) ./third_party/composer.sh
	$(BASH) ./third_party/gradle.sh
	$(BASH) ./third_party/pip.sh


.PHONY: help
