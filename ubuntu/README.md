## Ubuntu Recipes

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

$ op recipe add clivern/ubuntu/git -p ubuntu/git -t ubuntu,must_have,git -f
$ op recipe add clivern/ubuntu/wget -p ubuntu/wget -t ubuntu,must_have,wget -f
$ op recipe add clivern/ubuntu/curl -p ubuntu/curl -t ubuntu,must_have,curl -f

$ op recipe add clivern/ubuntu/python -p ubuntu/python -t ubuntu,must_have,python -f

$ op recipe add clivern/ubuntu/go -p ubuntu/go -t ubuntu,must_have,go -f
$ op recipe add clivern/ubuntu/rust -p ubuntu/rust -t ubuntu,must_have,rust -f
$ op recipe add clivern/ubuntu/elixir -p ubuntu/elixir -t ubuntu,must_have,elixir -f

$ op recipe add clivern/ubuntu/vim -p ubuntu/vim -t ubuntu,must_have,vim -f
$ op recipe add clivern/ubuntu/nvim -p ubuntu/nvim -t ubuntu,must_have,nvim -f
$ op recipe add clivern/ubuntu/terminator -p ubuntu/terminator -t ubuntu,must_have,terminator -f
$ op recipe add clivern/ubuntu/uv -p ubuntu/uv -t ubuntu,must_have,uv -f
$ op recipe add clivern/ubuntu/ruff -p ubuntu/ruff -t ubuntu,must_have,ruff -f
$ op recipe add clivern/ubuntu/terraform -p ubuntu/terraform -t ubuntu,must_have,terraform -f
$ op recipe add clivern/ubuntu/docker -p ubuntu/docker -t ubuntu,must_have,docker -f

$ op recipe add clivern/ubuntu/configs -p ubuntu/configs -t ubuntu,must_have,configs -f
```

2. Run recipes against localhost:

```bash
$ op recipe run clivern/ubuntu/git -h localhost
$ op recipe run clivern/ubuntu/wget -h localhost
$ op recipe run clivern/ubuntu/curl -h localhost
$ op recipe run clivern/ubuntu/python -h localhost
$ op recipe run clivern/ubuntu/go -h localhost
$ op recipe run clivern/ubuntu/rust -h localhost
$ op recipe run clivern/ubuntu/elixir -h localhost
$ op recipe run clivern/ubuntu/vim -h localhost
$ op recipe run clivern/ubuntu/nvim -h localhost
$ op recipe run clivern/ubuntu/terminator -h localhost
$ op recipe run clivern/ubuntu/uv -h localhost
$ op recipe run clivern/ubuntu/ruff -h localhost
$ op recipe run clivern/ubuntu/terraform -h localhost
$ op recipe run clivern/ubuntu/docker -h localhost
$ op recipe run clivern/ubuntu/configs -h localhost
```

#### Available Recipes

- **git** - Git version control system
- **wget** - Command-line utility for downloading files
- **curl** - Command-line tool for transferring data
- **python** - Python programming language and tools
- **go** - Go programming language
- **rust** - Rust programming language
- **vim** - Vim text editor
- **nvim** - Neovim text editor
- **pipx** - Python package installer for isolated environments
- **elixir** - Elixir programming language
- **terminator** - Advanced terminal emulator
- **uv** - Fast Python package installer and resolver
- **ruff** - Fast Python linter and formatter
- **terraform** - Infrastructure as Code tool for building, changing, and versioning infrastructure
- **docker** - Container platform for developing, shipping, and running applications
- **Chrome** - Manual Install.
- **Cursor IDE** - Manual Install.
