## Ubuntu Noble Recipes

This directory contains Ubuntu-specific recipes for installing various tools and packages using apt package manager.

### Installation Instructions

#### Prerequisites

1. Install `python` and `pip`:

```bash
$ sudo apt update
$ sudo apt install python3 python3-pip
```

2. Install `pipx`:

```bash
$ sudo apt install pipx
$ pipx ensurepath
```

3. Install `ansible`:

```bash
$ pipx install --include-deps ansible
$ pipx ensurepath
$ source ~/.bashrc
```

4. Install `OpsWork`:

```bash
$ pipx install opswork
```

5. Ensure `pipx` is in `PATH`:

```bash
$ pipx ensurepath
$ source ~/.bashrc
```

6. Initialize `OpsWork` configuration:

```bash
$ opswork config init
```

7. Add `Opswork` Alias:

```bash
$ alias op=opswork
```

#### Running Recipes

To install tools using the Ubuntu recipes:

1. Add `Ubuntu` recipes to `OpsWork`:

```bash
$ op host add localhost -i localhost -c local -f

$ op recipe add clivern/ubuntu/noble/git -p mini/ubuntu/noble/git -t ubuntu,must_have,git -f
$ op recipe add clivern/ubuntu/noble/wget -p mini/ubuntu/noble/wget -t ubuntu,must_have,wget -f
$ op recipe add clivern/ubuntu/noble/curl -p mini/ubuntu/noble/curl -t ubuntu,must_have,curl -f

$ op recipe add clivern/ubuntu/noble/python -p mini/ubuntu/noble/python -t ubuntu,must_have,python -f

$ op recipe add clivern/ubuntu/noble/go -p mini/ubuntu/noble/go -t ubuntu,must_have,go -f
$ op recipe add clivern/ubuntu/noble/rust -p mini/ubuntu/noble/rust -t ubuntu,must_have,rust -f
$ op recipe add clivern/ubuntu/noble/elixir -p mini/ubuntu/noble/elixir -t ubuntu,must_have,elixir -f

$ op recipe add clivern/ubuntu/noble/vim -p mini/ubuntu/noble/vim -t ubuntu,must_have,vim -f
$ op recipe add clivern/ubuntu/noble/nvim -p mini/ubuntu/noble/nvim -t ubuntu,must_have,nvim -f
$ op recipe add clivern/ubuntu/noble/terminator -p mini/ubuntu/noble/terminator -t ubuntu,must_have,terminator -f
$ op recipe add clivern/ubuntu/noble/uv -p mini/ubuntu/noble/uv -t ubuntu,must_have,uv -f
$ op recipe add clivern/ubuntu/noble/ruff -p mini/ubuntu/noble/ruff -t ubuntu,must_have,ruff -f
$ op recipe add clivern/ubuntu/noble/terraform -p mini/ubuntu/noble/terraform -t ubuntu,must_have,terraform -f
$ op recipe add clivern/ubuntu/noble/docker -p mini/ubuntu/noble/docker -t ubuntu,must_have,docker -f
$ op recipe add clivern/ubuntu/noble/txy -p mini/ubuntu/noble/txy -t ubuntu,must_have,txy -f

$ op recipe add clivern/ubuntu/noble/configs -p mini/ubuntu/noble/configs -t ubuntu,must_have,configs -f
```

2. Run recipes against localhost:

```bash
$ op recipe run clivern/ubuntu/noble/git -h localhost
$ op recipe run clivern/ubuntu/noble/wget -h localhost
$ op recipe run clivern/ubuntu/noble/curl -h localhost
$ op recipe run clivern/ubuntu/noble/python -h localhost
$ op recipe run clivern/ubuntu/noble/go -h localhost
$ op recipe run clivern/ubuntu/noble/rust -h localhost
$ op recipe run clivern/ubuntu/noble/elixir -h localhost
$ op recipe run clivern/ubuntu/noble/vim -h localhost
$ op recipe run clivern/ubuntu/noble/nvim -h localhost
$ op recipe run clivern/ubuntu/noble/terminator -h localhost
$ op recipe run clivern/ubuntu/noble/uv -h localhost
$ op recipe run clivern/ubuntu/noble/ruff -h localhost
$ op recipe run clivern/ubuntu/noble/terraform -h localhost
$ op recipe run clivern/ubuntu/noble/docker -h localhost
$ op recipe run clivern/ubuntu/noble/txy -h localhost
$ op recipe run clivern/ubuntu/noble/configs -h localhost
```
