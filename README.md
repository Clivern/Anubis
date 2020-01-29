<p align="center">
    <img alt="Logo" src="https://raw.githubusercontent.com/Clivern/dotfiles/master/img/logo.png" height="150" />
    <p align="center">
        <a href="https://travis-ci.org/Clivern/dotfiles"><img src="https://travis-ci.org/Clivern/dotfiles.svg?branch=master"></a>
        <img src="https://img.shields.io/badge/LICENSE-MIT-orange.svg">
    </p>
</p>

1. Clone the repository wherever you want. I like to keep it in `~/dotfiles`.

2. Define initial configs.

```zsh
$ export GIT_AUTHOR_NAME=Clivern
$ export GIT_AUTHOR_EMAIL=hello@clivern.com

$ export PERSONAL_SPACE_GIT_AUTHOR_NAME=Clivern
$ export PERSONAL_SPACE_GIT_AUTHOR_EMAIL=hello@clivern.com

$ export WORK_SPACE_GIT_AUTHOR_NAME=Clivern
$ export WORK_SPACE_GIT_AUTHOR_EMAIL=hello@clivern.com
```

3. Run `make build` to install packages.

4. Install all under `/dmg` manually.

5. Run `make sync` or `dotsync` to sync your dotfiles with the ones in home dir.

6. Add `access_token` & `gist_id` to configure [pet cli snippet manager](https://github.com/knqyf263/pet)

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

7. Configure Cargo.

```zsh
$ cargo login $TOKEN
```
