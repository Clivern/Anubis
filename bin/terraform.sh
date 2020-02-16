cd /tmp

export TERRAFORM_VERSION=0.12.18
echo "Installing Terraform v$TERRAFORM_VERSION"

curl -sS https://releases.hashicorp.com/terraform/{$TERRAFORM_VERSION}/terraform_{$TERRAFORM_VERSION}_darwin_amd64.zip > terraform.zip

unzip terraform.zip

chmod +x ./terraform

mv -f terraform /usr/local/bin/terraform

rm terraform.zip
