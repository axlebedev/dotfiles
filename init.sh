#!/bin/sh

mkdir -p ~/chrome-users

# create symlinks
rm ~/.conkyrc
ln -s ~/dotfiles/conky/.conkyrc ~/.conkyrc

rm ~/.vim/coc-settings.json
ln -s ~/dotfiles/.vim/coc-settings.json ~/.vim/coc-settings.json

rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc

rm ~/.ctags
ln -s ~/dotfiles/.ctags ~/.ctags

rm ~/.eslintrc
ln -s ~/dotfiles/.eslintrc ~/.eslintrc

rm ~/.gitconfig
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

rm ~/.vimrc
ln -s ~/dotfiles/.vimrc ~/.vimrc

rm ~/.vim/ftplugin
ln -s ~/dotfiles/.vim/ftplugin ~/.vim/ftplugin

rm ~/.i3
ln -s ~/dotfiles/.i3 ~/.i3

rm ~/.fzf.bash
ln -s ~/dotfiles/.fzf.bash ~/.fzf.bash

rm ~/.config/dunst
ln -s ~/dotfiles/dunst ~/.config/dunst

mkdir ~/.config/fish/
rm ~/.config/fish/config.fish
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

cp ~/dotfiles/desktop/skypeweb.desktop ~/.local/share/applications/

