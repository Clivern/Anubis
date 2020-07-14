cd /tmp

export POODLE_VERSION=0.0.2
export POODLE_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/Clivern/Poodle/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Poodle $POODLE_VERSION. Latest version is $POODLE_LATEST_VERSION"

curl -sL https://github.com/Clivern/Poodle/releases/download/{$POODLE_VERSION}/Poodle_{$POODLE_VERSION}_Darwin_x86_64.tar.gz | tar xz

chmod +x ./Poodle

mv -f Poodle /usr/local/bin/poodle
