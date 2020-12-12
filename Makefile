help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## hosts: Add localhost.
hosts:
	@echo ">> ============= Add localhost ============= <<"
	opswork host add localhost -i localhost -c local -f


## recipes: Load Recipes.
recipes:
	@COUNT=$$(yq -r '.recipes | length' dot.yml); \
	i=0; \
	while [[ $$i -lt $$COUNT ]]; do \
		name=$$(yq -r ".recipes[$$i].name" dot.yml); \
		path=$$(yq -r ".recipes[$$i].path" dot.yml); \
		tags=$$(yq -r ".recipes[$$i].tags" dot.yml); \
		opswork recipe add $$name -p $$path  -t $$tags -f; \
		i=$$((i+1)); \
	done


## config: Reload and sync configs
config:
	opswork recipe add clivern/dotfiles/configs -p configs -t dotfiles,must_have,configs -f
	opswork recipe run clivern/dotfiles/configs -h localhost


## run: Run Recipes.
run:
	@echo ">> ============= Run Recipes ============= <<"
	@for name in $$(yq -r '.run[].name' dot.yml); do \
		opswork recipe run $$name -h localhost; \
	done


.PHONY: help
