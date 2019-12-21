<p align="center">
    <img alt="Logo" src="https://raw.githubusercontent.com/Clivern/dotfiles/master/img/logo.png" height="150" />
    <p align="center">
        <a href="https://travis-ci.org/Clivern/dotfiles"><img src="https://travis-ci.org/Clivern/dotfiles.svg?branch=master"></a>
        <img src="https://img.shields.io/badge/LICENSE-MIT-orange.svg">
    </p>
</p>



1. Clone the repository wherever you want. I like to keep it in `~/Clivern/dotfiles`, with `~/dotfiles` as a symlink. Then run `make build` and it should set up everything.

2. Install all under `/dmg` manually

3. Add `access_token` & `gist_id` to configure [pet cli snippet manager](https://github.com/knqyf263/pet)
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
