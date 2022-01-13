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

- `clivern/golang:prod`: Used to run golang binary.
- `clivern/golang:prod-generic`: Used to run golang binary.
- `clivern/golang:generic`: Used to run golang binary.
- `clivern/rust:prod`: Used to run rust binary.
- `clivern/rust:prod-generic`: Used to run rust binary.
- `clivern/rust:generic`: Used to run rust binary.
- `clivern/elixir:1.13`: Used to run elixir project on production.
- `clivern/elixir:prod`: Used to run elixir project on production.
- `clivern/erlang:25`: Used to run erlang project on production.
- `clivern/erlang:prod`: Used to run erlang project on production.
