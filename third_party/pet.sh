cd /tmp

export PET_VERSION=0.3.6
echo "Installing Pet v$PET_VERSION"

curl -sL https://github.com/knqyf263/pet/releases/download/v{$PET_VERSION}/pet_{$PET_VERSION}_darwin_amd64.tar.gz | tar xz
mv pet /usr/local/bin/
