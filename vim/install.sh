cd /tmp

rm -rf ~/.vim_runtime 2> /dev/null
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
