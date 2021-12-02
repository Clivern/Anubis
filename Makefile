help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## build: Build My Environment.
build:
	@echo ">> ============= Build My Environment ============= <<"
	bash ./brew.sh
	bash ./zsh/install.sh
	bash ./composer/install.sh
	bash ./pip/install.sh
	bash ./pet/install.sh
	bash ./doctl/install.sh
	bash ./kubectl/install.sh
	bash ./tf_v1.1.9/install.sh
	bash ./glow/install.sh
	bash ./ngrok/install.sh
	bash ./rust_cargo/install.sh
	bash ./helm/install.sh
	bash ./ansible/install.sh
	bash ./goreleaser/install.sh
	bash ./github/install.sh
	bash ./apes/install.sh
	bash ./rhino/install.sh
	bash ./poodle/install.sh
	bash ./npm_pkgs/install.sh
	bash ./symfony/install.sh
	bash ./laravel/install.sh
	bash ./go_pkgs/install.sh
	bash ./hugo/install.sh
	bash ./fx/install.sh
	bash ./vim/install.sh
	bash ./nomad/install.sh
	bash ./consul/install.sh
	bash ./env.sh


## sync: Sync My dotfiles.
sync:
	@echo ">> ============= Sync My dotfiles ============= <<"
	bash bootstrap.sh
	bash extra.sh


.PHONY: help
