<p align="center">
    <img src="/static/logo.png" width="150" />
    <h3 align="center">dotfiles</h3>
</p>
<br/>

dotfiles are a very personal thing. They are shaped through years of experience, defeat, education, guidance taken, and ingenuity rewarded. Being without your personal configurations, you feel like a lost and helpless outsider in an unknown and hostile environment. You are uncomfortable and disoriented, yearning to return to a place of familiarity - a place you constructed through your own adventures, where all the shortcuts are well-traveled, and which you proudly call `$HOME`.


### Usage

1. Clone the repository wherever you want. I like to keep it in `~/dotfiles`.

2. Install [flook](https://pypi.org/project/flook/) globally.

```zsh
$ pip install flook
```

3. Init the configs

```zsh
$ flook config init
$ flook config dump
```

4. Add local as a host.

```zsh
$ make hsync
```

5. Add dotfiles recipes.

```zsh
$ make rsync
```

6. Run recipes one by one or the needed ones. for example to run `clivern/ping` towards host with name `localhost`.

```zsh
$ flook recipe run clivern/ping -h localhost

# To get the must have list
$ flook recipe list -t must_have -o json | jq .
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Dotfiles** is authored and maintained by [@clivern](http://github.com/clivern).

