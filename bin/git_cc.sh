cd /tmp

export GIT_CC_VERSION=0.0.5
export GIT_CC_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/SKalt/git-cc/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing git-cc v$GIT_CC_VERSION. Latest version is $GIT_CC_LATEST_VERSION"

curl -sL https://github.com/SKalt/git-cc/releases/download/v{$GIT_CC_VERSION}/git-cc_{$GIT_CC_VERSION}_darwin_amd64.tar.gz | tar xz

chmod +x ./git-cc

mv -f git-cc $LOCAL_BIN/git-cc