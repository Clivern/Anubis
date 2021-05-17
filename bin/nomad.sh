cd /tmp

export NOMAD_VERSION=1.0.5
echo "Installing Nomad v$NOMAD_VERSION"

curl -sS https://releases.hashicorp.com/nomad/{$NOMAD_VERSION}/nomad_{$NOMAD_VERSION}_darwin_amd64.zip > nomad.zip

unzip nomad.zip

chmod +x ./nomad

mv -f nomad /usr/local/bin/nomad

rm nomad.zip
