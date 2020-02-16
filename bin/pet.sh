cd /tmp

export PET_VERSION=0.3.6
export PET_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/knqyf263/pet/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Pet v$PET_VERSION. Latest version is $PET_LATEST_VERSION"

curl -sL https://github.com/knqyf263/pet/releases/download/v{$PET_VERSION}/pet_{$PET_VERSION}_darwin_amd64.tar.gz | tar xz

chmod +x ./pet

mv -f pet /usr/local/bin/pet
