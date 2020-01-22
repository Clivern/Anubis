<p align="center">
    <img alt="Logo" src="https://raw.githubusercontent.com/Clivern/dotfiles/master/img/logo.png" height="150" />
    <p align="center">
        <a href="https://travis-ci.org/Clivern/dotfiles"><img src="https://travis-ci.org/Clivern/dotfiles.svg?branch=master"></a>
        <img src="https://img.shields.io/badge/LICENSE-MIT-orange.svg">
    </p>
</p>


1. Clone the repository wherever you want. I like to keep it in `~/dotfiles`.

2. Run `make build` to install packages.

3. Install all under `/dmg` manually.

4. Run `make sync` to sync your dotfiles with the ones in home dir.

5. Add `access_token` & `gist_id` to configure [pet cli snippet manager](https://github.com/knqyf263/pet)
```zsh
$ pet configure
```

```toml
[Gist]
  file_name = "pet-snippet.toml"
  access_token = "~~~"
  gist_id = "~~~"
  public = false
  auto_sync = false
```

```zsh
$ pet sync
```

```zsh
$ petgrep ping
```
