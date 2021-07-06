<p align="center">
    <img src="/logo.png" width="300" />
    <h3 align="center">Home</h3>
</p>

Dotfiles are a very personal thing. They are shaped through years of experience, defeat, education, guidance taken, and ingenuity rewarded. Being without your personal configurations, you feel like a lost and helpless outsider in an unknown and hostile environment. You are uncomfortable and disoriented, yearning to return to a place of familiarity - a place you constructed through your own adventures, where all the shortcuts are well-traveled, and which you proudly call `$HOME`


### Usage

1. Clone the repository wherever you want. I like to keep it in `~/dotfiles`.

2. Define initial configs.

```zsh
$ export GIT_AUTHOR_NAME=Clivern
$ export GIT_AUTHOR_EMAIL=hello@clivern.com

$ export PERSONAL_SPACE_GIT_AUTHOR_NAME=Clivern
$ export PERSONAL_SPACE_GIT_AUTHOR_EMAIL=hello@clivern.com

$ export WORK_SPACE_GIT_AUTHOR_NAME=Clivern
$ export WORK_SPACE_GIT_AUTHOR_EMAIL=hello@clivern.com

# Get from https://pushover.net/
$ export PUSHOVER_TOKEN="~~~app-token-here~~~"
$ export PUSHOVER_USER="~~~user-key-here~~~"

```

3. Run `make build` to install packages.

5. Run `make sync` or `dsync` to sync your dotfiles with the ones in home dir.

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

8. Configure Github Client.

```zsh
$ gh issue list
```

9. Configure [Poodle](https://github.com/Clivern/Poodle)

```
$ poodle configure
```
