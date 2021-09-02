cd /tmp

export REVIVE_VERSION=1.0.6
export REVIVE_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/mgechev/revive/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing revive $REVIVE_VERSION. Latest version is $REVIVE_LATEST_VERSION"

curl -sL https://github.com/mgechev/revive/releases/download/v{$REVIVE_VERSION}/revive_{$REVIVE_VERSION}_Darwin_x86_64.tar.gz | tar xz

chmod +x ./revive

mv -f revive $LOCAL_BIN/revive
