#!/bin/bash

filler="                                   "

# clear log file, if exists
logFile="$(pwd)/update_vim.log"
echo "starting at $(date)" >${logFile}

# '-E' is to save use variables, $HOME
[ "$UID" -eq 0 ] || exec sudo -E "$0" "$@"

# define colors
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m' # No Color
COLOR_INVERTED='\033[7m'

IGNORE_GIT=0
while getopts "g" v; do
    IGNORE_GIT=1
done

# check if update necessary
cd $HOME/github/vim/
current_commit=$(git rev-parse HEAD)

printf "Checking for updates...\n"
eval `ssh-agent -s` >>${logFile} 2>>${logFile}
ssh-add $HOME/.ssh/id_rsa >>${logFile} 2>>${logFile}
git fetch >>${logFile} 2>>${logFile}
last_commit=$(git rev-parse origin/master)
# if [[ IGNORE_GIT == 0 && "$current_commit" == "$last_commit" ]]; \
# then
#     printf "${COLOR_GREEN}VIM IS ALREADY UP TO DATE${COLOR_RESET}"
#     printf "${filler}"
#     printf "\n"
#     rm ${logFile}
#     exit 0
# fi
# printf "\n"

printf "Starting update...\n"

printf "${COLOR_YELLOW}pull vim sources...${COLOR_RESET}\r"
if [[ $(basename "$PWD") == "dotfiles" ]]; then
    echo "You're in dotfiles"
    exit 1
fi

if git reset --hard origin/master >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}pull vim sources OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}pull vim sources ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}apt install deps...${COLOR_RESET}\r"
if sudo apt install -y \
    liblua5.1-dev \
    luajit \
    libluajit-5.1-dev \
    ruby-dev \
    libperl-dev \
    libncurses5-dev \
    libatk1.0-dev \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}apt-get install deps OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}apt-get install deps ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}apt build-dep vim...${COLOR_RESET}\r"
if sudo apt build-dep -y vim >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}apt build-dep OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}apt build-dep ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}distclean...${COLOR_RESET}\r"
if cd src/ && sudo make distclean >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}distclean OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}distclean ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}configure...${COLOR_RESET}\r"
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
    >>${logFile} 2>>${logFile} \
then
then
    printf "${COLOR_GREEN}configure OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}configure ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}make...${COLOR_RESET}\r"
if sudo make >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}make OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}make ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}make install...${COLOR_RESET}\r"
if sudo make install >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}make install OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}make install ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

printf "${COLOR_YELLOW}update javascript-typescript-langserver...${COLOR_RESET}\r"
if sudo npm i -g javascript-typescript-langserver >>${logFile} 2>>${logFile}; \
then
    printf "${COLOR_GREEN}update javascript-typescript-langserver OK${COLOR_RESET}"
    printf "${filler}\n\r"
else
    printf "${COLOR_RED}update javascript-typescript-langserver ERRORED${COLOR_RESET}"
    printf "${filler}\n\r"
    exit 1
fi

# printf "${COLOR_YELLOW}PlugUpdate...${COLOR_RESET}\r"
# if gvim +'PlugUpdate --sync' +qa >>${logFile} 2>>${logFile}; \
# then
#     printf "${COLOR_GREEN}PlugUpdate OK${COLOR_RESET}"
#     printf "${filler}\n\r"
# else
#     printf "${COLOR_RED}PlugUpdate ERRORED${COLOR_RESET}"
#     printf "${filler}\n\r"
#     exit 1
# fi

printf "\n${COLOR_YELLOW}VIM UPDATED SUCCESSFULLTY!!${COLOR_RESET}\n"
vim --version  >>${logFile} 2>>${logFile}

printf "\n${COLOR_GREEN}UPDATES:${COLOR_RESET}\n"
git log --format="%C(cyan)%h%Cgreen (%ad)%Creset - %f %Cblue<%an>%Creset" --date=format:"%H:%M %d.%m.%Y" $current_commit..HEAD

rm ${logFile}

exit 0
