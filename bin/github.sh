cd /tmp

export GITHUB_VERSION=1.2.1
export GITHUB_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/cli/cli/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Github v$GITHUB_VERSION. Latest version is $GITHUB_LATEST_VERSION"

curl -sL https://github.com/cli/cli/releases/download/v{$GITHUB_VERSION}/gh_{$GITHUB_VERSION}_macOS_amd64.tar.gz | tar xz

chmod +x ./gh_*/bin/gh

mv -f ./gh_*/bin/gh /usr/local/bin/gh

gh --version
