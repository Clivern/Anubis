cd /tmp

export RHINO_VERSION=1.2.1
export RHINO_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/Clivern/Rhino/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Rhino $RHINO_VERSION. Latest version is $RHINO_LATEST_VERSION"

curl -sL https://github.com/Clivern/Rhino/releases/download/{$RHINO_VERSION}/Rhino_{$RHINO_VERSION}_Darwin_x86_64.tar.gz | tar xz

chmod +x ./Rhino

mv -f Rhino /usr/local/bin/rhino
