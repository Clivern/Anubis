cd /tmp

export HELM_VERSION=3.0.2
echo "Installing Helm v$HELM_VERSION"

curl -sL https://get.helm.sh/helm-v{$HELM_VERSION}-darwin-amd64.tar.gz | tar xz

chmod +x ./darwin-amd64/helm

mv -f ./darwin-amd64/helm /usr/local/bin/helm
