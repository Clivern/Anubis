help: Makefile
	@echo
	@echo " Choose a command run in Matrix:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## hosts: Add localhost.
hosts:
	@echo ">> ============= Add localhost ============= <<"
	opswork host add localhost -i localhost -c local -f


## recipes: Load Recipes.
recipes:
	opswork batch load setup.yml --force


## config: Reload and sync configs
config:
	opswork recipe add clivern/matrix/configs -p configs -t matrix,must_have,configs -f
	opswork recipe run clivern/matrix/configs -h localhost


## run: Run Recipes.
run:
	opswork batch run setup.yml -h localhost


## rnvcache: Clean Neovim cache
rnvcache:
	@echo ">> ============= Clean Neovim cache ============= <<"
	rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim


## serve: Serve Website.
serve:
	@echo ">> ============= Serve Website ============= <<"
	cd docs; bundle exec jekyll serve


.PHONY: help
