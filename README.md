<p align="center">
    <img alt="Logo" src="https://dotfiles.github.io/images/dotfiles-logo.png" height="80" />
</p>

## Installation

1. Clone the repository wherever you want. I like to keep it in `~/Clivern/dotfiles`, with `~/dotfiles` as a symlink. Then run `make build` and it should set up everything. 

2. Install all under `/dmg` manually

3. Add `access_token` & `gist_id` to configure Pet cli snippet manager
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
