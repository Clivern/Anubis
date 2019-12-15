help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## build: Build My Environment.
build:
	@echo ">> ============= Build My Environment ============= <<"


.PHONY: help
