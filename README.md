<p align="center">
    <img src="https://raw.githubusercontent.com/Clivern/Kemet/main/screenshot01.png?v=3.1.2" width="600" />
    <h3 align="center">Kemet</h3>
    <p align="center">
        <a href="https://github.com/Clivern/Kemet/actions/workflows/ci.yml">
           <img src="https://github.com/Clivern/Kemet/actions/workflows/ci.yml/badge.svg?branch=main"/>
        </a>
        <a href="https://pypi.org/project/opswork/">
            <img src="https://img.shields.io/badge/Built_with-OpsWork-blue"/>
        </a>
        <a href="https://github.com/Clivern/Kemet/releases">
            <img src="https://img.shields.io/badge/Version-3.1.2-1abc9c.svg">
        </a>
        <a href="https://github.com/Clivern/Kemet/blob/master/LICENSE">
            <img src="https://img.shields.io/badge/LICENSE-MIT-blue.svg">
        </a>
    </p>
</p>
<br/>

`Dotfiles` are a very personal thing. They are shaped through years of experience, defeat, education, guidance taken, and ingenuity rewarded. Being without your personal configurations, you feel like a lost and helpless outsider in an unknown and hostile environment. You are uncomfortable and disoriented, yearning to return to a place of familiarity - a place you constructed through your own adventures, where all the shortcuts are well-traveled, and which you proudly call `$HOME`.


### Usage

1. Clone the repository.

```zsh
# Create space directory
$ mkdir -p ~/space

$ git clone git@github.com:Clivern/Kemet.git ~/space/kemet
```

2. Install [opswork](https://pypi.org/project/opswork/) globally.

```zsh
$ brew install yq

$ pip install ansible
$ pip install opswork
```

3. Init the configs

```zsh
$ opswork config init
$ opswork config dump
```

4. Add local as a host.

```zsh
$ make hosts
```

5. Add dotfiles recipes.

```zsh
$ make recipes
```

6. Run recipes one by one or the needed ones. for example to run `clivern/ping` towards host with name `localhost`.

```zsh
$ opswork recipe run clivern/linux/ping -h localhost -v key=value

# To get the must have list
$ opswork recipe list -t must_have -o json | jq .
```

6. To install dotfiles.

```zsh
$ make run
```

7. To run command either locally or remotely.

```zsh
# Add a Remote Linux Host
$ opswork host add clivern -i ~x.x.x.x~ -p 22 -u ~user~ -s /Users/root/.ssh/id_rsa.pem

# Check Uptime
$ opswork recipe run clivern/linux/cmd -h clivern -v cmd="uptime"

# Ping Remote Host
$ opswork recipe run clivern/linux/ping -h clivern

# Update
$ opswork recipe run clivern/linux/update -h clivern

# Upgrade
$ opswork recipe run clivern/linux/upgrade -h clivern

# Force Reboot
$ opswork recipe run clivern/linux/cmd -h clivern -v cmd="reboot"

# SSH to any Host
$ opswork host ssh clivern
```

8. Store the secrets in `OpsWork` vault.

```zsh
$ op secret add clivern/ai/google_palm_api_key "~~" -t ai
$ op secret add clivern/ai/openai_api_key "~~" -t ai
```

9. Secret can be loaded as environmental variable by adding it to `configs/secrets.j2` like the following.

```zsh
$ export OPENAI_API_KEY="$(op secret get clivern/ai/openai_api_key -o json | jq '.[0].value')"
```

10. To load secrets from terminal.

```zsh
$ source ~/.secrets
```


### License

© 2010, Clivern. Released under [MIT License](https://opensource.org/licenses/mit-license.php).

**Kemet** is authored and maintained by [@clivern](http://github.com/clivern).

