<p align="center">
    <img src="/img/logo.png" width="150" />
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
$ flook recipe add clivern/brew/update -p brew/update
$ flook recipe add clivern/brew/upgrade -p brew/upgrade

$ flook recipe add clivern/ping -p recipe/ping
$ flook recipe add clivern/brew/ack -p brew/ack
$ flook recipe add clivern/brew/asciinema -p brew/asciinema
$ flook recipe add clivern/brew/bat -p brew/bat
$ flook recipe add clivern/brew/curl -p brew/curl
$ flook recipe add clivern/brew/elixir -p brew/elixir
$ flook recipe add clivern/brew/fzf -p brew/fzf
$ flook recipe add clivern/brew/git -p brew/git
$ flook recipe add clivern/brew/git-crypt -p brew/git-crypt
$ flook recipe add clivern/brew/go -p brew/go
$ flook recipe add clivern/brew/gradle -p brew/gradle
$ flook recipe add clivern/brew/groovy -p brew/groovy
$ flook recipe add clivern/brew/httpie -p brew/httpie
$ flook recipe add clivern/brew/kubectx -p brew/kubectx
$ flook recipe add clivern/brew/mysql -p brew/mysql
$ flook recipe add clivern/brew/mysql-client -p brew/mysql-client
$ flook recipe add clivern/brew/node -p brew/node
$ flook recipe add clivern/brew/php -p brew/php
$ flook recipe add clivern/brew/python -p brew/python
$ flook recipe add clivern/brew/rbenv -p brew/rbenv
$ flook recipe add clivern/brew/screen -p brew/screen
$ flook recipe add clivern/brew/task -p brew/task
$ flook recipe add clivern/brew/tfswitch -p brew/tfswitch
$ flook recipe add clivern/brew/tmux -p brew/tmux
$ flook recipe add clivern/brew/tree -p brew/tree
$ flook recipe add clivern/brew/ttyrec -p brew/ttyrec
$ flook recipe add clivern/brew/watch -p brew/watch
$ flook recipe add clivern/brew/wget -p brew/wget
$ flook recipe add clivern/brew/yarn -p brew/yarn
$ flook recipe add clivern/brew/ytt -p brew/ytt
```

6. Run recipes one by one or the needed ones.

```zsh
$ flook recipe run clivern/ping -h localhost
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Dotfiles** is authored and maintained by [@clivern](http://github.com/clivern).

