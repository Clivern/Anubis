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
	opswork recipe add clivern/dotfiles/update -p brew/update -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/upgrade -p brew/upgrade -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/caddy -p caddy -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/consul -p consul -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/packer -p packer -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/nomad -p nomad -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/vault -p vault -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/ack -p ack -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/curl -p curl -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/bat -p bat -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/python -p python -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/php -p php -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/node -p node -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/nmap -p nmap -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/mysql -p mysql -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/kubectx -p kubectx -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/kubectl -p kubectl -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/k6 -p k6 -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/iterm -p iterm -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/httpie -p httpie -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/screen -p screen -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/tfswitch -p tfswitch -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/watch -p watch -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/wget -p wget -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/ytt -p ytt -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/task -p task -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/tmux -p tmux -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/tree -p tree -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/ttyrec -p ttyrec -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/pipx -p pipx -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/cowsay -p cowsay -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/poetry -p poetry -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/pyinfra -p pyinfra -t dotfiles,must_have -f
	opswork recipe add clivern/dotfiles/openllm -p openllm -t dotfiles,must_have -f


## run: Run Recipes.
run:
	@echo ">> ============= Run Recipes ============= <<"
	opswork recipe run clivern/dotfiles/update -h localhost
	opswork recipe run clivern/dotfiles/upgrade -h localhost
	opswork recipe run clivern/dotfiles/caddy -h localhost
	opswork recipe run clivern/dotfiles/consul -h localhost
	opswork recipe run clivern/dotfiles/packer -h localhost
	opswork recipe run clivern/dotfiles/nomad -h localhost
	opswork recipe run clivern/dotfiles/vault -h localhost
	opswork recipe run clivern/dotfiles/ack -h localhost
	opswork recipe run clivern/dotfiles/curl -h localhost
	opswork recipe run clivern/dotfiles/bat -h localhost
	opswork recipe run clivern/dotfiles/python -h localhost
	opswork recipe run clivern/dotfiles/php -h localhost
	opswork recipe run clivern/dotfiles/node -h localhost
	opswork recipe run clivern/dotfiles/nmap -h localhost
	opswork recipe run clivern/dotfiles/mysql -h localhost
	opswork recipe run clivern/dotfiles/kubectx -h localhost
	opswork recipe run clivern/dotfiles/kubectl -h localhost
	opswork recipe run clivern/dotfiles/k6 -h localhost
	# opswork recipe run clivern/dotfiles/iterm -h localhost
	opswork recipe run clivern/dotfiles/httpie -h localhost
	opswork recipe run clivern/dotfiles/screen -h localhost
	opswork recipe run clivern/dotfiles/tfswitch -h localhost
	opswork recipe run clivern/dotfiles/watch -h localhost
	opswork recipe run clivern/dotfiles/wget -h localhost
	opswork recipe run clivern/dotfiles/ytt -h localhost
	opswork recipe run clivern/dotfiles/task -h localhost
	opswork recipe run clivern/dotfiles/tmux -h localhost
	opswork recipe run clivern/dotfiles/tree -h localhost
	opswork recipe run clivern/dotfiles/ttyrec -h localhost
	opswork recipe run clivern/dotfiles/pipx -h localhost
	opswork recipe run clivern/dotfiles/cowsay -h localhost
	opswork recipe run clivern/dotfiles/poetry -h localhost
	opswork recipe run clivern/dotfiles/pyinfra -h localhost
	opswork recipe run clivern/dotfiles/openllm -h localhost


.PHONY: help
