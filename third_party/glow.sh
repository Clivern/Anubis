cd /tmp

export GLOW_VERSION=0.1.3
echo "Installing Glow v$GLOW_VERSION"

curl -sL https://github.com/charmbracelet/glow/releases/download/v{$GLOW_VERSION}/glow_{$GLOW_VERSION}_Darwin_x86_64.tar.gz | tar xz

chmod +x ./glow

mv glow /usr/local/bin/glow
