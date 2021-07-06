> When you live in a command line, configurations are a deeply personal thing. They are often crafted over years of 
experience, battles lost, lessons learned, advice followed, and ingenuity rewarded. When you are away from your own 
configurations, you are an orphaned refugee in unfamiliar and hostile surroundings. You feel clumsy and out of sorts. You 
are filled with a sense of longing to be back in a place you know. A place you built. A place where all the short-cuts 
have been worn bare by your own travels. A place you proudly call… `$HOME`. ~ yadm


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

