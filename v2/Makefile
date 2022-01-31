help: Makefile
	@echo
	@echo " Choose a command run in dotfiles:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## local: Add localhost
local:
	@echo ">> ============= Add localhost ============= <<"
	flook host add localhost -i localhost -c local


## sync: Sync Recipes.
sync:
	@echo ">> ============= Sync Recipes ============= <<"
	flook recipe add clivern/dotfiles/update -p brew/update -t dotfiles,must_have
	flook recipe add clivern/dotfiles/upgrade -p brew/upgrade -t dotfiles,must_have
	flook recipe add clivern/ping -p linux/ping -t dotfiles,must_have
	flook recipe add clivern/dotfiles/ack -p ack -t dotfiles
	flook recipe add clivern/dotfiles/ansible -p ansible -t dotfiles,must_have
	flook recipe add clivern/dotfiles/apes -p apes -t dotfiles
	flook recipe add clivern/dotfiles/arduino -p arduino -t dotfiles
	flook recipe add clivern/dotfiles/asciinema -p asciinema -t dotfiles
	flook recipe add clivern/dotfiles/aws -p aws -t dotfiles,must_have
	flook recipe add clivern/dotfiles/bat -p bat -t dotfiles
	flook recipe add clivern/dotfiles/bazel -p bazel -t dotfiles
	flook recipe add clivern/dotfiles/composer -p composer -t dotfiles
	flook recipe add clivern/dotfiles/consul -p consul -t dotfiles
	flook recipe add clivern/dotfiles/curl -p curl -t dotfiles
	flook recipe add clivern/dotfiles/docker -p docker -t dotfiles
	flook recipe add clivern/dotfiles/doctl -p doctl -t dotfiles
	flook recipe add clivern/dotfiles/elixir -p elixir -t dotfiles,must_have
	flook recipe add clivern/dotfiles/fx -p fx -t dotfiles
	flook recipe add clivern/dotfiles/fzf -p fzf -t dotfiles
	flook recipe add clivern/dotfiles/git -p git -t dotfiles,must_have
	flook recipe add clivern/dotfiles/git-crypt -p crypt -t dotfiles
	flook recipe add clivern/dotfiles/git_cc -p git_cc -t dotfiles
	flook recipe add clivern/dotfiles/github -p github -t dotfiles,must_have
	flook recipe add clivern/dotfiles/glow -p glow -t dotfiles
	flook recipe add clivern/dotfiles/go -p go -t dotfiles,must_have
	flook recipe add clivern/dotfiles/go_pkgs -p go_pkgs -t dotfiles
	flook recipe add clivern/dotfiles/goenv -p goenv -t dotfiles,must_have
	flook recipe add clivern/dotfiles/goreleaser -p goreleaser -t dotfiles,must_have
	flook recipe add clivern/dotfiles/gradle -p gradle -t dotfiles,must_have
	flook recipe add clivern/dotfiles/groovy -p groovy -t dotfiles,must_have
	flook recipe add clivern/dotfiles/habitat -p habitat -t dotfiles
	flook recipe add clivern/dotfiles/helidon -p helidon -t dotfiles
	flook recipe add clivern/dotfiles/helm -p helm -t dotfiles
	flook recipe add clivern/dotfiles/httpie -p httpie -t dotfiles,must_have
	flook recipe add clivern/dotfiles/hugo -p hugo -t dotfiles
	flook recipe add clivern/dotfiles/iterm -p iterm -t dotfiles,must_have
	flook recipe add clivern/dotfiles/k6 -p k6 -t dotfiles
	flook recipe add clivern/dotfiles/kubectl -p kubectl -t dotfiles,must_have
	flook recipe add clivern/dotfiles/kubectx -p kubectx -t dotfiles,must_have
	flook recipe add clivern/dotfiles/kustomize -p kustomize -t dotfiles
	flook recipe add clivern/dotfiles/laravel -p laravel -t dotfiles,must_have
	flook recipe add clivern/dotfiles/mvn -p mvn -t dotfiles,must_have
	flook recipe add clivern/dotfiles/mysql -p mysql -t dotfiles,must_have
	flook recipe add clivern/dotfiles/mysql-client -p client -t dotfiles,must_have
	flook recipe add clivern/dotfiles/ngrok -p ngrok -t dotfiles,must_have
	flook recipe add clivern/dotfiles/node -p node -t dotfiles,must_have
	flook recipe add clivern/dotfiles/nomad -p nomad -t dotfiles
	flook recipe add clivern/dotfiles/npm_pkgs -p npm_pkgs -t dotfiles
	flook recipe add clivern/dotfiles/packer -p packer -t dotfiles
	flook recipe add clivern/dotfiles/pet -p pet -t dotfiles
	flook recipe add clivern/dotfiles/php -p php -t dotfiles,must_have
	flook recipe add clivern/dotfiles/pip -p pip -t dotfiles,must_have
	flook recipe add clivern/dotfiles/poetry -p poetry -t dotfiles
	flook recipe add clivern/dotfiles/poodle -p poodle -t dotfiles
	flook recipe add clivern/dotfiles/pushover -p pushover -t dotfiles
	flook recipe add clivern/dotfiles/python -p python -t dotfiles,must_have
	flook recipe add clivern/dotfiles/rbenv -p rbenv -t dotfiles,must_have
	flook recipe add clivern/dotfiles/revive -p revive -t dotfiles,must_have
	flook recipe add clivern/dotfiles/rhino -p rhino -t dotfiles
	flook recipe add clivern/dotfiles/rust -p rust -t dotfiles,must_have
	flook recipe add clivern/dotfiles/screen -p screen -t dotfiles
	flook recipe add clivern/dotfiles/sq -p sq -t dotfiles
	flook recipe add clivern/dotfiles/svu -p svu -t dotfiles
	flook recipe add clivern/dotfiles/symfony -p symfony -t dotfiles
	flook recipe add clivern/dotfiles/task -p task -t dotfiles
	flook recipe add clivern/dotfiles/tfswitch -p tfswitch -t dotfiles,must_have
	flook recipe add clivern/dotfiles/tilt -p tilt -t dotfiles
	flook recipe add clivern/dotfiles/tlstool -p tlstool -t dotfiles
	flook recipe add clivern/dotfiles/tmux -p tmux -t dotfiles
	flook recipe add clivern/dotfiles/tree -p tree -t dotfiles
	flook recipe add clivern/dotfiles/ttyrec -p ttyrec -t dotfiles
	flook recipe add clivern/dotfiles/vault -p vault -t dotfiles
	flook recipe add clivern/dotfiles/vim -p vim -t dotfiles,must_have
	flook recipe add clivern/dotfiles/watch -p watch -t dotfiles
	flook recipe add clivern/dotfiles/wget -p wget -t dotfiles,must_have
	flook recipe add clivern/dotfiles/yarn -p yarn -t dotfiles
	flook recipe add clivern/dotfiles/ytt -p ytt -t dotfiles
	flook recipe add clivern/dotfiles/zsh -p zsh -t dotfiles,must_have


.PHONY: help
