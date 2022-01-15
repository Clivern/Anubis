### Usage

1. Create `hub.pkrvars.json` from `tpl.hub.pkrvars.json` with the docker hub credentials

```
{"username": "$$$", "password": "$$$"}
```

2. Run `ci`

```zsh
$ make ci
```

3. Build and push docker images

```zsh
$ make golang
$ make rust
$ make erlang
$ make elixir
```


### Images

- [golang](https://hub.docker.com/r/clivern/golang/tags) docker images.
- [rust](https://hub.docker.com/r/clivern/rust/tags) docker images.
- [elixir](https://hub.docker.com/r/clivern/elixir/tags) docker images.
- [erlang](https://hub.docker.com/r/clivern/erlang/tags) docker images.
