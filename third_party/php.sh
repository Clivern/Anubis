cd /tmp

export PHP_VERSION=7.3
echo "Installing PHP v$PHP_VERSION"

curl -s http://php-osx.liip.ch/install.sh | bash -s 7.3
