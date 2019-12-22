cd /tmp

export DOCTL_VERSION=1.36.0
echo "Installing Doctl v$DOCTL_VERSION"

curl -sL https://github.com/digitalocean/doctl/releases/download/v{$DOCTL_VERSION}/doctl-{$DOCTL_VERSION}-darwin-amd64.tar.gz | tar xz

chmod +x ./doctl

mv doctl /usr/local/bin/doctl
