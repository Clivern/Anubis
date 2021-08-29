cd /tmp

export FZF_VERSION=0.27.2
wget https://github.com/junegunn/fzf/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-darwin_amd64.zip 
unzip fzf-$FZF_VERSION-darwin_amd64.zip

chmod +x ./fzf

mv -f fzf $LOCAL_BIN/fzf
