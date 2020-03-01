cd /tmp

echo "Installing oh-my-zsh"

# Install zsh
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

echo "Y" | sh install.sh

brew install zsh-syntax-highlighting
