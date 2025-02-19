<p align="center">
    <img src="https://raw.githubusercontent.com/clivern/anubis/main/static/logo.png" width="20%" />
    <h3 align="center">Anubis</h3>
    <p align="center">My Personal dotfiles</p>
    <p align="center">
        <a href="https://github.com/Clivern/Anubis/actions/workflows/ci.yml">
           <img src="https://github.com/Clivern/Anubis/actions/workflows/ci.yml/badge.svg?branch=main"/>
        </a>
        <a href="https://clivern.betteruptime.com/">
           <img src="https://uptime.betterstack.com/status-badges/v2/monitor/1evgt.svg"/>
        </a>
        <a href="https://pypi.org/project/opswork/">
            <img src="https://img.shields.io/badge/Built_with-OpsWork-blue"/>
        </a>
        <a href="https://radar.thoughtworks.com/?documentId=https%3A%2F%2Fraw.githubusercontent.com%2FClivern%2FAnubis%2Fmain%2Ftradar.json">
            <img src="https://img.shields.io/badge/Technology-Radar-green.svg">
        </a>
        <a href="https://github.com/Clivern/Anubis/releases">
            <img src="https://img.shields.io/badge/Version-5.5.0-1abc9c.svg">
        </a>
        <a href="https://github.com/Clivern/Anubis/blob/master/LICENSE">
            <img src="https://img.shields.io/badge/LICENSE-MIT-blue.svg">
        </a>
    </p>
    <br/>
    <p align="center">
	     <img src="https://raw.githubusercontent.com/clivern/anubis/main/static/shot_01.png" width="95%" />
	</p>
</p>
<br/>


### Usage

1. Clone the repository.

```zsh
# Create space directory
$ mkdir -p ~/space

$ git clone git@github.com:clivern/anubis.git ~/space/anubis
```

2. Install the following manually

- [Homebrew](https://brew.sh/)
- [Google Chrome](https://www.google.com/intl/en_uk/chrome/)
- [Iterm2](https://iterm2.com/)
- [omz](https://ohmyz.sh/)
- [Sublime](https://www.sublimetext.com/)
- [Fonts for Terminal & Neovim](./fonts/)


3. Install [opswork](https://pypi.org/project/opswork/) and `pip` globally.

```zsh
$ brew install yq
$ brew install python@3.11

$ pip install -r requirements.freeze.txt
$ alias op=opswork
```

4. Init the configs

```zsh
$ op config init
$ op config dump
```

5. Add local as a host.

```zsh
$ make hosts
```

6. Add dotfiles recipes.

```zsh
$ make recipes
```

7. Run recipes one by one or the needed ones. for example to run `clivern/ping` towards host with name `localhost`.

```zsh
$ op recipe run clivern/linux/ping -h localhost -v key=value

# To get the must have list
$ op recipe list -t must_have -o json | jq .
```

8. To install dotfiles.

```zsh
$ make run
```

9. To run command either locally or remotely.

```zsh
# Add a Remote Linux Host
$ op host add clivern -i ~x.x.x.x~ -p 22 -u ~user~ -s /Users/root/.ssh/id_rsa.pem

# Check Uptime
$ op recipe run clivern/linux/cmd -h clivern -v cmd="uptime"

# Ping Remote Host
$ op recipe run clivern/linux/ping -h clivern

# Update
$ op recipe run clivern/linux/update -h clivern

# Upgrade
$ op recipe run clivern/linux/upgrade -h clivern

# Force Reboot
$ op recipe run clivern/linux/cmd -h clivern -v cmd="reboot"

# SSH to any Host
$ op host ssh clivern
```

10. Store the secrets in `OpsWork` vault.

```zsh
$ op secret add clivern/ai/google_palm_api_key "~~" -t ai
$ op secret add clivern/ai/openai_api_key "~~" -t ai
```

11. Secret can be loaded as environmental variable by adding it to `configs/secrets.j2` like the following.

```zsh
$ export OPENAI_API_KEY="$(op secret get clivern/ai/openai_api_key -o json | jq -r '.[0].value')"
```

12. To load secrets from terminal.

```zsh
$ source ~/.secrets
```

13. To list all recipes

```
$ op recipe list -o json | jq -r '.[].name'
```


### Ngrok Usage

To install `ngrok`

```zsh
$ op recipe run clivern/anubis/ngrok -h localhost
```

To add `ngrok` secrets like the `key` and `domain`

```zsh
# Define ngrok key and domain
$ op secret add clivern/ngrok_domain "x.x.x.ngrok-free.app" -t ngrok
$ op secret add clivern/ngrok_key "xxxxxxxxx" -t ngrok

$ source ~/.secrets
```

To configure `ngrok` auth token

```zsh
$ ngrok config add-authtoken $NGROK_KEY
```

To proxy to local port `8000`

```zsh
$ ngrok http --domain=$NGROK_DOMAIN 8000
```


### LSP Servers

Add recipes

```zsh
$ make recipes
```

Install LSP servers

```
$ opswork recipe run clivern/anubis/lsp -h localhost
```


### Technology Radar

My Technology Radar is stored in `tradar.json`

```json
[
  {
    "name": "..",
    "ring": "adopt or trial or assess or hold",
    "quadrant": "tools or techniques or platforms or languages-and-frameworks",
    "isNew": "FALSE or TRUE",
    "description": ".."
  }
]
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Anubis** is authored and maintained by [@clivern](http://github.com/clivern).
