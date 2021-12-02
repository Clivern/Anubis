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
	bash ./zsh/install
	bash ./composer/install
	bash ./pip/install
	bash ./pet/install
	bash ./doctl/install
	bash ./kubectl/install
	bash ./tf_v1.1.9/install
	bash ./glow/install
	bash ./ngrok/install
	bash ./rust_cargo/install
	bash ./helm/install
	bash ./ansible/install
	bash ./goreleaser/install
	bash ./github/install
	bash ./apes/install
	bash ./rhino/install
	bash ./poodle/install
	bash ./npm_pkgs/install
	bash ./symfony/install
	bash ./laravel/install
	bash ./go_pkgs/install
	bash ./hugo/install
	bash ./fx/install
	bash ./vim/install
	bash ./nomad/install
	bash ./consul/install
	bash ./env.sh


## sync: Sync My dotfiles.
sync:
	@echo ">> ============= Sync My dotfiles ============= <<"
	bash bootstrap.sh
	bash extra.sh


.PHONY: help
