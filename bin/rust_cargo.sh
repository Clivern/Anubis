cd /tmp

echo "Installing Rust & Cargo"

curl -Lo install.sh https://sh.rustup.rs
sh install.sh -y

source $HOME/.cargo/env

# https://crates.io/crates/orc-rs
cargo install --force orc-rs