cd /tmp

export DOCTL_VERSION=1.42.0
export DOCTL_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/digitalocean/doctl/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Doctl v$DOCTL_VERSION. Latest version is $DOCTL_LATEST_VERSION"

curl -sL https://github.com/digitalocean/doctl/releases/download/v{$DOCTL_VERSION}/doctl-{$DOCTL_VERSION}-darwin-amd64.tar.gz | tar xz

chmod +x ./doctl

mv -f doctl /usr/local/bin/doctl
