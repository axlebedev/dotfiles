#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m' # No Color
COLOR_INVERTED='\033[7m'
printf "${COLOR_GREEN}Starting...${COLOR_RESET}\n\n"

printf "${COLOR_YELLOW}apt-get install deps...${COLOR_RESET}\n"
if sudo apt-get install -y \
    liblua5.1-dev \
    luajit \
    libluajit-5.1 \
    python-dev \
    ruby-dev \
    libperl-dev \
    libncurses5-dev \
    libatk1.0-dev \
    libx11-dev \
    libxpm-dev \
    libxt-dev; \
then
    printf "${COLOR_GREEN}apt-get install deps OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}apt-get install deps ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}apt build-dep vim...${COLOR_RESET}\n"
if sudo apt build-dep -y vim; \
then
    printf "${COLOR_GREEN}apt build-dep OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}apt build-dep ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}pull vim sources...${COLOR_RESET}\n"
cd ~/github/vim/
if git pull; \
then
    printf "${COLOR_GREEN}pull vim sources OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}pull vim sources ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}distclean...${COLOR_RESET}\n"
if cd src/ && sudo make distclean; \
then
    printf "${COLOR_GREEN}distclean OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}distclean ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}configure...${COLOR_RESET}\n"
if ./configure \
    --enable-luainterp=yes \
    --enable-mzschemeinterp \
    --enable-perlinterp=yes \
    --enable-pythoninterp=yes \
    --enable-python3interp=yes \
    --enable-tclinterp=yes \
    --enable-rubyinterp=yes \
    --enable-cscope \
    --enable-multibyte \
    --enable-fontset \
    --with-features=huge \
    --enable-gui=auto \
    --enable-gtk2-check \
    --with-x \
then
then
    printf "${COLOR_GREEN}configure OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}configure ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}make...${COLOR_RESET}\n"
if sudo make; \
then
    printf "${COLOR_GREEN}make OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}make ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_YELLOW}make && make install...${COLOR_RESET}\n"
if sudo make install; \
then
    printf "${COLOR_GREEN}make install OK${COLOR_RESET}\n\n"
else
    printf "${COLOR_RED}make install ERRORED${COLOR_RESET}\n\n"
    exit 1
fi

printf "${COLOR_GREEN}VIM UPDATED SUCCESSFULLTY!!${COLOR_RESET}\n"
vim --version
exit 0
