
echo "Installing Clivern Sublime Snippets"

cd $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages
export SNIPPETS_LATEST_VERSION=$(curl --silent "https://api.github.com/repos/Clivern/Snippets/releases/latest" | jq '.tag_name' | sed -E 's/.*"([^"]+)".*/\1/')

rm -rf Snippets
curl -sL https://github.com/Clivern/Snippets/archive/{$SNIPPETS_LATEST_VERSION}.tar.gz | tar xz
mv Snippets-* Snippets
