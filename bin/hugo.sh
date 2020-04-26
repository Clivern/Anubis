cd /tmp

export HUGO_VERSION=0.69.2
export HUGO_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/gohugoio/hugo/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Hugo v$HUGO_VERSION. Latest version is $HUGO_LATEST_VERSION"

curl -sL https://github.com/gohugoio/hugo/releases/download/v{$HUGO_VERSION}/hugo_{$HUGO_VERSION}_macOS-64bit.tar.gz | tar xz

chmod +x ./hugo

mv -f hugo /usr/local/bin/hugo
