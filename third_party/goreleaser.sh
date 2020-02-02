cd /tmp

export GO_RELEASER_VERSION=0.125.0
echo "Installing GoReleaser v$GO_RELEASER_VERSION"

curl -sL https://github.com/goreleaser/goreleaser/releases/download/v{$GO_RELEASER_VERSION}/goreleaser_Darwin_x86_64.tar.gz | tar xz

chmod +x ./goreleaser

mv goreleaser /usr/local/bin/goreleaser
