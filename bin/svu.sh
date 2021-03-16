cd /tmp

export SVU_VERSION=1.3.2
export SVU_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/caarlos0/svu/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Installing Svu v$SVU_VERSION. Latest version is $SVU_LATEST_VERSION"

curl -sL https://github.com/caarlos0/svu/releases/download/v{$SVU_VERSION}/svu_{$SVU_VERSION}_darwin_amd64.tar.gz | tar xz

chmod +x ./svu

mv -f svu /usr/local/bin/svu
