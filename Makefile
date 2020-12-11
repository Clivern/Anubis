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
	@echo ">> ============= Load Recipes ============= <<"
	@while read -r line; do \
		name=$$(echo $$line | cut -d'=' -f1); \
		path=$$(echo $$line | cut -d'=' -f2); \
		tags=$$(echo $$line | cut -d'=' -f3); \
		opswork recipe add $$name -p $$path  -t $$tags -f; \
	done < .dot.load


## run: Run Recipes.
run:
	@echo ">> ============= Run Recipes ============= <<"
	@while read -r line; do \
		name=$$(echo $$line); \
		opswork recipe run $$name -h localhost; \
	done < .dot.install


.PHONY: help
