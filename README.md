<p align="center">
    <img alt="Logo" src="https://dotfiles.github.io/images/dotfiles-logo.png" height="80" />
</p>

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. I like to keep it in `~/Clivern/dotfiles`, with `~/dotfiles` as a symlink. Then run `make build` and it should set up everything.

### Configure Pet CLI Snippet Manager with Github

Add `access_token` & `gist_id`

```bash
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
