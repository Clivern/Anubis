cd /tmp

echo "Installing Rust & Cargo"

curl -Lo install.sh https://sh.rustup.rs
sh install.sh -y

source $HOME/.cargo/env
