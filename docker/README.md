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
```

### Images

- `clivern/golang:prod`: Used to run golang binary.
- `clivern/golang:prod-generic`: Used to run golang binary.
- `clivern/golang:generic`: Used to run golang binary.
- `clivern/rust:prod`: Used to run rust binary.
- `clivern/rust:prod-generic`: Used to run rust binary.
- `clivern/rust:generic`: Used to run rust binary.
