#!/bin/sh
cp -f ~/workspace/shell/autoSyncDotFiles.sh /home/nyankosama/workspace/github/dotfiles
cp -f ~/.vimrc ~/.zshrc ~/.tmux.conf ~/.ycm_extra_conf.py /home/nyankosama/workspace/github/dotfiles/home
cp -f /usr/share/vim/vim74/colors/* /home/nyankosama/workspace/github/dotfiles/vim/colors 
cd /home/nyankosama/workspace/github/dotfiles
DATE=$(date +%Y%m%d)
git add -A
git commit -m "${DATE}"
git push origin master
