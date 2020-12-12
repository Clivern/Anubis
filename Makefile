help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## hosts: Add localhost
hosts:
	@echo ">> ============= Add localhost ============= <<"
	opswork host add localhost -i localhost -c local -f


## recipes: Sync Recipes.
recipes:
	@echo ">> ============= Sync Recipes ============= <<"
	opswork recipe add clivern/dotfiles/update -p brew/update -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/upgrade -p brew/upgrade -t dotfiles,must_have -f


## run: Run a recipe
run:
	@echo ">> ============= Run Recipes ============= <<"
	opswork recipe run clivern/dotfiles/update -h localhost
	opswork recipe run clivern/dotfiles/upgrade -h localhost


.PHONY: help
