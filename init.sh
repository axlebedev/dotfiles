#!/bin/sh

mkdir -p ~/chrome-users

# create symlinks
rm -rf ~/.conkyrc
ln -s ~/dotfiles/conky/.conkyrc ~/.conkyrc

rm -rf ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc

rm -rf ~/.ctags
ln -s ~/dotfiles/.ctags ~/.ctags

rm -rf ~/.eslintrc
ln -s ~/dotfiles/.eslintrc ~/.eslintrc

rm -rf ~/.gitconfig
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

rm -rf ~/.vimrc
ln -s ~/dotfiles/.vimrc ~/.vimrc

rm -rf ~/.vim/ftplugin
ln -s ~/dotfiles/.vim/ftplugin ~/.vim/ftplugin

rm -rf ~/.vim/coc-settings.json
ln -s ~/dotfiles/.vim/coc-settings.json ~/.vim/coc-settings.json

rm -rf ~/.vim/pack
ln -s ~/dotfiles/.vim/pack ~/.vim/pack

rm -rf ~/.i3
ln -s ~/dotfiles/.i3 ~/.i3

rm -rf ~/.fzf.bash
ln -s ~/dotfiles/.fzf.bash ~/.fzf.bash

rm -rf ~/.config/dunst
ln -s ~/dotfiles/dunst ~/.config/dunst

mkdir ~/.config/fish/
rm -rf ~/.config/fish/config.fish
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

cp ~/dotfiles/desktop/skypeweb.desktop ~/.local/share/applications/

