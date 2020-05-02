cd /tmp

export GO_RELEASER_VERSION=0.132.1
export GO_RELEASER_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/goreleaser/goreleaser/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing GoReleaser v$GO_RELEASER_VERSION. Latest version is $GO_RELEASER_LATEST_VERSION"

curl -sL https://github.com/goreleaser/goreleaser/releases/download/v{$GO_RELEASER_VERSION}/goreleaser_Darwin_x86_64.tar.gz | tar xz

chmod +x ./goreleaser

mv -f goreleaser /usr/local/bin/goreleaser
