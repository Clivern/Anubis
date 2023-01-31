<p align="center">
    <img src="/static/logo.png" width="150" />
    <h3 align="center">dotfiles</h3>
</p>
<br/>

dotfiles are a very personal thing. They are shaped through years of experience, defeat, education, guidance taken, and ingenuity rewarded. Being without your personal configurations, you feel like a lost and helpless outsider in an unknown and hostile environment. You are uncomfortable and disoriented, yearning to return to a place of familiarity - a place you constructed through your own adventures, where all the shortcuts are well-traveled, and which you proudly call `$HOME`.


### Usage

1. Clone the repository wherever you want. I like to keep it in `~/dotfiles`.

2. Install [flook](https://github.com/norwik/flook/) globally.

```zsh
$ pip install flook
```

3. Init the configs

```zsh
$ flook config init
```

4. Add local as a host.

```zsh
$ flook host add localhost -i localhost -c local
```

5. Add dotfiles recipes.

```zsh
$ flook recipe add clivern/dotfiles/update -p brew/update -t dotfiles
$ flook recipe add clivern/dotfiles/upgrade -p brew/upgrade -t dotfiles
$ flook recipe add clivern/ping -p linux/ping -t dotfiles

$ flook recipe add clivern/dotfiles/ack -p ack -t dotfiles
$ flook recipe add clivern/dotfiles/ansible -p ansible -t dotfiles
$ flook recipe add clivern/dotfiles/apes -p apes -t dotfiles
$ flook recipe add clivern/dotfiles/arduino -p arduino -t dotfiles
$ flook recipe add clivern/dotfiles/asciinema -p asciinema -t dotfiles
$ flook recipe add clivern/dotfiles/aws -p aws -t dotfiles
$ flook recipe add clivern/dotfiles/bat -p bat -t dotfiles
$ flook recipe add clivern/dotfiles/bazel -p bazel -t dotfiles
$ flook recipe add clivern/dotfiles/composer -p composer -t dotfiles
$ flook recipe add clivern/dotfiles/consul -p consul -t dotfiles
$ flook recipe add clivern/dotfiles/curl -p curl -t dotfiles
$ flook recipe add clivern/dotfiles/docker -p docker -t dotfiles
$ flook recipe add clivern/dotfiles/doctl -p doctl -t dotfiles
$ flook recipe add clivern/dotfiles/elixir -p elixir -t dotfiles
$ flook recipe add clivern/dotfiles/fx -p fx -t dotfiles
$ flook recipe add clivern/dotfiles/fzf -p fzf -t dotfiles
$ flook recipe add clivern/dotfiles/git -p git -t dotfiles
$ flook recipe add clivern/dotfiles/git-crypt -p crypt -t dotfiles
$ flook recipe add clivern/dotfiles/git_cc -p git_cc -t dotfiles
$ flook recipe add clivern/dotfiles/github -p github -t dotfiles
$ flook recipe add clivern/dotfiles/glow -p glow -t dotfiles
$ flook recipe add clivern/dotfiles/go -p go -t dotfiles
$ flook recipe add clivern/dotfiles/go_pkgs -p go_pkgs -t dotfiles
$ flook recipe add clivern/dotfiles/goenv -p goenv -t dotfiles
$ flook recipe add clivern/dotfiles/goreleaser -p goreleaser -t dotfiles
$ flook recipe add clivern/dotfiles/gradle -p gradle -t dotfiles
$ flook recipe add clivern/dotfiles/groovy -p groovy -t dotfiles
$ flook recipe add clivern/dotfiles/habitat -p habitat -t dotfiles
$ flook recipe add clivern/dotfiles/helidon -p helidon -t dotfiles
$ flook recipe add clivern/dotfiles/helm -p helm -t dotfiles
$ flook recipe add clivern/dotfiles/httpie -p httpie -t dotfiles
$ flook recipe add clivern/dotfiles/hugo -p hugo -t dotfiles
$ flook recipe add clivern/dotfiles/iterm -p iterm -t dotfiles
$ flook recipe add clivern/dotfiles/k6 -p k6 -t dotfiles
$ flook recipe add clivern/dotfiles/kubectl -p kubectl -t dotfiles
$ flook recipe add clivern/dotfiles/kubectx -p kubectx -t dotfiles
$ flook recipe add clivern/dotfiles/kustomize -p kustomize -t dotfiles
$ flook recipe add clivern/dotfiles/laravel -p laravel -t dotfiles
$ flook recipe add clivern/dotfiles/linux -p linux -t dotfiles
$ flook recipe add clivern/dotfiles/mvn -p mvn -t dotfiles
$ flook recipe add clivern/dotfiles/mysql -p mysql -t dotfiles
$ flook recipe add clivern/dotfiles/mysql-client -p client -t dotfiles
$ flook recipe add clivern/dotfiles/ngrok -p ngrok -t dotfiles
$ flook recipe add clivern/dotfiles/node -p node -t dotfiles
$ flook recipe add clivern/dotfiles/nomad -p nomad -t dotfiles
$ flook recipe add clivern/dotfiles/npm_pkgs -p npm_pkgs -t dotfiles
$ flook recipe add clivern/dotfiles/packer -p packer -t dotfiles
$ flook recipe add clivern/dotfiles/pet -p pet -t dotfiles
$ flook recipe add clivern/dotfiles/php -p php -t dotfiles
$ flook recipe add clivern/dotfiles/pip -p pip -t dotfiles
$ flook recipe add clivern/dotfiles/poetry -p poetry -t dotfiles
$ flook recipe add clivern/dotfiles/poodle -p poodle -t dotfiles
$ flook recipe add clivern/dotfiles/pushover -p pushover -t dotfiles
$ flook recipe add clivern/dotfiles/python -p python -t dotfiles
$ flook recipe add clivern/dotfiles/rbenv -p rbenv -t dotfiles
$ flook recipe add clivern/dotfiles/revive -p revive -t dotfiles
$ flook recipe add clivern/dotfiles/rhino -p rhino -t dotfiles
$ flook recipe add clivern/dotfiles/rust -p rust -t dotfiles
$ flook recipe add clivern/dotfiles/screen -p screen -t dotfiles
$ flook recipe add clivern/dotfiles/sq -p sq -t dotfiles
$ flook recipe add clivern/dotfiles/svu -p svu -t dotfiles
$ flook recipe add clivern/dotfiles/symfony -p symfony -t dotfiles
$ flook recipe add clivern/dotfiles/task -p task -t dotfiles
$ flook recipe add clivern/dotfiles/tfswitch -p tfswitch -t dotfiles
$ flook recipe add clivern/dotfiles/tilt -p tilt -t dotfiles
$ flook recipe add clivern/dotfiles/tlstool -p tlstool -t dotfiles
$ flook recipe add clivern/dotfiles/tmux -p tmux -t dotfiles
$ flook recipe add clivern/dotfiles/tree -p tree -t dotfiles
$ flook recipe add clivern/dotfiles/ttyrec -p ttyrec -t dotfiles
$ flook recipe add clivern/dotfiles/vault -p vault -t dotfiles
$ flook recipe add clivern/dotfiles/vim -p vim -t dotfiles
$ flook recipe add clivern/dotfiles/watch -p watch -t dotfiles
$ flook recipe add clivern/dotfiles/wget -p wget -t dotfiles
$ flook recipe add clivern/dotfiles/yarn -p yarn -t dotfiles
$ flook recipe add clivern/dotfiles/ytt -p ytt -t dotfiles
$ flook recipe add clivern/dotfiles/zsh -p zsh -t dotfiles
```

6. Run recipes one by one or the needed ones.

```zsh
$ flook recipe run clivern/ping -h localhost

$ flook recipe run clivern/dotfiles/ack -h localhost
$ flook recipe run clivern/dotfiles/ansible -h localhost
$ flook recipe run clivern/dotfiles/apes -h localhost
$ flook recipe run clivern/dotfiles/arduino -h localhost
$ flook recipe run clivern/dotfiles/asciinema -h localhost
$ flook recipe run clivern/dotfiles/aws -h localhost
$ flook recipe run clivern/dotfiles/bat -h localhost
$ flook recipe run clivern/dotfiles/bazel -h localhost
$ flook recipe run clivern/dotfiles/composer -h localhost
$ flook recipe run clivern/dotfiles/consul -h localhost
$ flook recipe run clivern/dotfiles/curl -h localhost
$ flook recipe run clivern/dotfiles/docker -h localhost
$ flook recipe run clivern/dotfiles/doctl -h localhost
$ flook recipe run clivern/dotfiles/elixir -h localhost
$ flook recipe run clivern/dotfiles/fx -h localhost
$ flook recipe run clivern/dotfiles/fzf -h localhost
$ flook recipe run clivern/dotfiles/git -h localhost
$ flook recipe run clivern/dotfiles/git-crypt -h localhost
$ flook recipe run clivern/dotfiles/git_cc -h localhost
$ flook recipe run clivern/dotfiles/github -h localhost
$ flook recipe run clivern/dotfiles/glow -h localhost
$ flook recipe run clivern/dotfiles/go -h localhost
$ flook recipe run clivern/dotfiles/go_pkgs -h localhost
$ flook recipe run clivern/dotfiles/goenv -h localhost
$ flook recipe run clivern/dotfiles/goreleaser -h localhost
$ flook recipe run clivern/dotfiles/gradle -h localhost
$ flook recipe run clivern/dotfiles/groovy -h localhost
$ flook recipe run clivern/dotfiles/habitat -h localhost
$ flook recipe run clivern/dotfiles/helidon -h localhost
$ flook recipe run clivern/dotfiles/helm -h localhost
$ flook recipe run clivern/dotfiles/httpie -h localhost
$ flook recipe run clivern/dotfiles/hugo -h localhost
$ flook recipe run clivern/dotfiles/iterm -h localhost
$ flook recipe run clivern/dotfiles/k6 -h localhost
$ flook recipe run clivern/dotfiles/kubectl -h localhost
$ flook recipe run clivern/dotfiles/kubectx -h localhost
$ flook recipe run clivern/dotfiles/kustomize -h localhost
$ flook recipe run clivern/dotfiles/laravel -h localhost
$ flook recipe run clivern/dotfiles/mvn -h localhost
$ flook recipe run clivern/dotfiles/mysql -h localhost
$ flook recipe run clivern/dotfiles/mysql-client -h localhost
$ flook recipe run clivern/dotfiles/ngrok -h localhost
$ flook recipe run clivern/dotfiles/node -h localhost
$ flook recipe run clivern/dotfiles/nomad -h localhost
$ flook recipe run clivern/dotfiles/npm_pkgs -h localhost
$ flook recipe run clivern/dotfiles/packer -h localhost
$ flook recipe run clivern/dotfiles/pet -h localhost
$ flook recipe run clivern/dotfiles/php -h localhost
$ flook recipe run clivern/dotfiles/pip -h localhost
$ flook recipe run clivern/dotfiles/poetry -h localhost
$ flook recipe run clivern/dotfiles/poodle -h localhost
$ flook recipe run clivern/dotfiles/pushover -h localhost
$ flook recipe run clivern/dotfiles/python -h localhost
$ flook recipe run clivern/dotfiles/rbenv -h localhost
$ flook recipe run clivern/dotfiles/revive -h localhost
$ flook recipe run clivern/dotfiles/rhino -h localhost
$ flook recipe run clivern/dotfiles/rust -h localhost
$ flook recipe run clivern/dotfiles/screen -h localhost
$ flook recipe run clivern/dotfiles/sq -h localhost
$ flook recipe run clivern/dotfiles/svu -h localhost
$ flook recipe run clivern/dotfiles/symfony -h localhost
$ flook recipe run clivern/dotfiles/task -h localhost
$ flook recipe run clivern/dotfiles/tfswitch -h localhost
$ flook recipe run clivern/dotfiles/tilt -h localhost
$ flook recipe run clivern/dotfiles/tlstool -h localhost
$ flook recipe run clivern/dotfiles/tmux -h localhost
$ flook recipe run clivern/dotfiles/tree -h localhost
$ flook recipe run clivern/dotfiles/ttyrec -h localhost
$ flook recipe run clivern/dotfiles/vault -h localhost
$ flook recipe run clivern/dotfiles/vim-h localhost
$ flook recipe run clivern/dotfiles/watch -h localhost
$ flook recipe run clivern/dotfiles/wget -h localhost
$ flook recipe run clivern/dotfiles/yarn -h localhost
$ flook recipe run clivern/dotfiles/ytt -h localhost
$ flook recipe run clivern/dotfiles/zsh -h localhost
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Dotfiles** is authored and maintained by [@clivern](http://github.com/clivern).

