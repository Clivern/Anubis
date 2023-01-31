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
$ flook recipe add clivern/dotfiles/asciinema -p asciinema -t dotfiles
$ flook recipe add clivern/dotfiles/bat -p bat -t dotfiles
$ flook recipe add clivern/dotfiles/curl -p curl -t dotfiles
$ flook recipe add clivern/dotfiles/elixir -p elixir -t dotfiles
$ flook recipe add clivern/dotfiles/fzf -p fzf -t dotfiles
$ flook recipe add clivern/dotfiles/git -p git -t dotfiles
$ flook recipe add clivern/dotfiles/git-crypt -p git-crypt -t dotfiles
$ flook recipe add clivern/dotfiles/go -p go -t dotfiles
$ flook recipe add clivern/dotfiles/gradle -p gradle -t dotfiles
$ flook recipe add clivern/dotfiles/groovy -p groovy -t dotfiles
$ flook recipe add clivern/dotfiles/httpie -p httpie -t dotfiles
$ flook recipe add clivern/dotfiles/kubectx -p kubectx -t dotfiles
$ flook recipe add clivern/dotfiles/mysql -p mysql -t dotfiles
$ flook recipe add clivern/dotfiles/mysql-client -p mysql-client -t dotfiles
$ flook recipe add clivern/dotfiles/node -p node -t dotfiles
$ flook recipe add clivern/dotfiles/php -p php -t dotfiles
$ flook recipe add clivern/dotfiles/python -p python -t dotfiles
$ flook recipe add clivern/dotfiles/rbenv -p rbenv -t dotfiles
$ flook recipe add clivern/dotfiles/screen -p screen -t dotfiles
$ flook recipe add clivern/dotfiles/task -p task -t dotfiles
$ flook recipe add clivern/dotfiles/tfswitch -p tfswitch -t dotfiles
$ flook recipe add clivern/dotfiles/tmux -p tmux -t dotfiles
$ flook recipe add clivern/dotfiles/tree -p tree -t dotfiles
$ flook recipe add clivern/dotfiles/ttyrec -p ttyrec -t dotfiles
$ flook recipe add clivern/dotfiles/watch -p watch -t dotfiles
$ flook recipe add clivern/dotfiles/wget -p wget -t dotfiles
$ flook recipe add clivern/dotfiles/yarn -p yarn -t dotfiles
$ flook recipe add clivern/dotfiles/ytt -p ytt -t dotfiles
```

6. Run recipes one by one or the needed ones.

```zsh
$ flook recipe run clivern/ping -h localhost

$ flook recipe run clivern/dotfiles/ack -h localhost
$ flook recipe run clivern/dotfiles/asciinema -h localhost
$ flook recipe run clivern/dotfiles/bat -h localhost
$ flook recipe run clivern/dotfiles/curl -h localhost
$ flook recipe run clivern/dotfiles/elixir -h localhost
$ flook recipe run clivern/dotfiles/fzf -h localhost
$ flook recipe run clivern/dotfiles/git -h localhost
$ flook recipe run clivern/dotfiles/git-crypt -h localhost
$ flook recipe run clivern/dotfiles/go -h localhost
$ flook recipe run clivern/dotfiles/gradle -h localhost
$ flook recipe run clivern/dotfiles/groovy -h localhost
$ flook recipe run clivern/dotfiles/httpie -h localhost
$ flook recipe run clivern/dotfiles/kubectx -h localhost
$ flook recipe run clivern/dotfiles/mysql -h localhost
$ flook recipe run clivern/dotfiles/mysql-client -h localhost
$ flook recipe run clivern/dotfiles/node -h localhost
$ flook recipe run clivern/dotfiles/php -h localhost
$ flook recipe run clivern/dotfiles/python -h localhost
$ flook recipe run clivern/dotfiles/rbenv -h localhost
$ flook recipe run clivern/dotfiles/screen -h localhost
$ flook recipe run clivern/dotfiles/task -h localhost
$ flook recipe run clivern/dotfiles/tfswitch -h localhost
$ flook recipe run clivern/dotfiles/tmux -h localhost
$ flook recipe run clivern/dotfiles/tree -h localhost
$ flook recipe run clivern/dotfiles/ttyrec -h localhost
$ flook recipe run clivern/dotfiles/watch -h localhost
$ flook recipe run clivern/dotfiles/wget -h localhost
$ flook recipe run clivern/dotfiles/yarn -h localhost
$ flook recipe run clivern/dotfiles/ytt -h localhost
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Dotfiles** is authored and maintained by [@clivern](http://github.com/clivern).

