cd /tmp

export HELM_VERSION=3.2.0
echo "Installing Helm v$HELM_VERSION"

curl -sL https://get.helm.sh/helm-v{$HELM_VERSION}-darwin-amd64.tar.gz | tar xz

chmod +x ./darwin-amd64/helm

mv -f ./darwin-amd64/helm $LOCAL_BIN/helm
