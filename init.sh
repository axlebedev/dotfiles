#!/bin/sh
# create symlinks
rm ~/.conkyrc
ln -s ~/dotfiles/.conkyrc ~/.conkyrc
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
rm ~/.i3
ln -s ~/dotfiles/.i3 ~/.i3
rm ~/.config/fish/config.fish
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/config.fish

