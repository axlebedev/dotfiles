# =================================================================================================
# === LINUX INSTALL ===============================================================================
# ----- Установка нужных программ -----
sudo add-apt-repository -y ppa:agornostal/ulauncher && \
sudo add-apt-repository -y ppa:git-core/ppa && \
sudo apt-add-repository -y ppa:fish-shell/release-3 %% \
sudo apt update

# Убрать заголовок в окне gnome-terminal
gsettings set org.gnome.Terminal.Legacy.Settings headerbar "@mb false"   
# Или в dconf-editor: org.gnome.Terminal.Legacy.Settings headerbar - uncheck "use default" - В custom ввести "False"
# menubar убрать в гуи настройках самого терминала
# После этого перелогиниться

# Добавить ключи ssh для гитхаба
ssh-keygen -t rsa -C "alexey.broadcast@gmail.com"
cat .ssh/id_rsa.pub

# initial installation
# jshon \ # for clickable i3-status
# feh \ # background picture in i3
# dconf-settings \ # turn off show device on auto-mount
# ttf-ancient-fonts \ # если проблема с unicode-символами
# python3-smbc samba smbclient \ # for ya printer
# unclutter \ # скрыть курсор мыши при наборе текста
# autorandr \ # надо буудет сохранить профили
# screenkey # для показа нажатой кнопки

sudo apt install -y \
git \
curl \
conky \
build-essential \
silversearcher-ag \
network-manager-l2tp \
network-manager-l2tp-gnome \
i3 \
ulauncher \
jshon \
fonts-font-awesome \
feh \
screenruler \
fzf fish \
ttf-ancient-fonts \
python3-smbc samba
xkb-switch \
unclutter \
autorandr \
xserver-xorg-input-libinput \
screenkey \
snapd \
nodejs npm \
cmake libxkbfile-dev \
flameshot

# indicator-sound-switcher \ # меню звук-девайсов в трее
# gromit-mpx \ # для рисования на экране
# simplescreenrecorder \ # для записи скринкастов
# flameshot # для скриншотов
sudo snap install \
diff-so-fancy \
indicator-sound-switcher \
gromit-mpx \
simplescreenrecorder \

sudo snap install -classic node

# ----- install Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update 
# maybe sudo apt install libnss3
sudo apt install google-chrome-stable

# ===== dotfiles ==================================================================================
cd ~ && \
git clone git@github.com:axlebedev/dotfiles.git && \
~/dotfiles/init.sh

# ===== VIM =======================================================================================
# поставить галочку в Software sources -> enable source code repositories
sudo apt install \
liblua5.1-dev \
luajit \
libluajit-5.1-dev \
python2-dev \
ruby-dev \
libperl-dev
libncurses5-dev \
libatk1.0-dev \
libx11-dev \
libxpm-dev \
libxt-dev

# install xkb-switch
cd ~/github
git clone git@github.com:grwlf/xkb-switch.git
cd xkb-switch/
mkdir build && cd build
cmake ..
make && sudo make install

# В /etc/apt/sources.list надо скопипасить cтрочку
# ...ubuntu version
# и дать концовкy 'main restricted universe main multiverse'
# Получится что-то типа
# deb-src http://mirror.yandex.ru/ubuntu xenial main restricted universe main multiverse

sudo apt build-dep vim
cd ~ && mkdir github && cd ~/github
git clone git@github.com:vim/vim.git 
cd vim/src
sudo make distclean

./configure \
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
--with-x

sudo make && sudo make install

curl -fLo ~/.vim/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# font here: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete%20Mono.otf

# ===== I3 GAPS ============================================
sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool

# Install xcb-util-xrm
cd ~/github
git clone https://github.com/Airblader/xcb-util-xrm
cd xcb-util-xrm
git submodule update --init
./autogen.sh --prefix=/usr
make && sudo make install

# Install i3-gaps
cd ~/github

sudo apt purge i3
sudo apt install meson dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
mkdir -p build && cd build
meson --prefix /usr/local
ninja
sudo ninja install




# ----- install i3-lock
# i3lock установить в соотв. с инструкцией, всё должно собраться 
# https://raymond.li/i3lock-color/

# ===== FISH ======================================================================================
# https://hackercodex.com/guide/install-fish-shell-mac-ubuntu/
# or-my-fish:
curl -L http://get.oh-my.fish | fish
omf install bobthefish # prev: agnoster # theme
omf theme bobthefish # prev: agnoster # don't forget to enable powerline-nerd-font
# plugins
omf install cd
omf install sudope # TODO: разобраться и настроить
# for z: https://github.com/rupa/z/blob/master/z.sh to $path
omf install z # TODO разобраться и навешать алиасов

# ===== Чтобы не отсоединялся wi-fi ===============================================================
# ПОМОГЛО: обновить убунту до 22
# sudo  journalctl -b 0 -u NetworkManager
#
# Another way to debug the issue is to raise the logging level with the following change to /etc/NetworkManager/NetworkManager.conf:
# [logging]
# level=DEBUG
# Then run the following to get better messages in /var/log/syslog:
# sudo systemctl restart NetworkManager
#
# Alternative Solution
# Another option is to disable connectivity checking:
# [connectivity]
# interval=0
#
# 1
# Try disabling powersave for Wi-Fi. In /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf set:
# wifi.powersave = 2

# 2
# nmcli connection modify <Your VPN connection name> connection.autoconnect-retries 0
# nmcli connection modify <Your VPN connection name> vpn.persistent yes

# 3
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'

# 4 Disable IPV6
# 5 Если ничего не помогло - в стандартном убунтовском окошке с настройками wi-fi можно указать авто-VPN

# 6 В старом гисте был ещё такой коммент:
# Чтобы не выключался wi-fi https://askubuntu.com/questions/1030653/wifi-randomly-disconnected-on-ubuntu-18-04-lts

# 7
# /etc/NetworkManager/NetworkManager.conf
# change
# `managed=false`
# to
# `managed=true`
# and reboot

===================================================================================================

Чтобы работал `npm link`
Нужно поменять путь установки глобальных пакетов на домашний:
https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ~/.profile

NOTE: пакет который мы хотим залинковать, нигде не должен быть установлен, ни в одном node_modules других пакетов! Поэтому node_modules где он может встречаться лучше удалить


# ===== Доп. настройки ============================================================================
# open nemo with --no-desktop
gsettings set org.nemo.desktop show-desktop-icons false

# Node without sudo, ports under 1024
sudo setcap 'cap_net_bind_service=+ep' `which node`

# hot plugging displays:
systemctl enable autorandr.service
# https://www.reddit.com/r/i3wm/comments/bxil6o/i3wm_and_hotplugging_monitors/

# Чтобы не выключался звук https://askubuntu.com/questions/1015384/keep-audio-awake
# закомментить "idle" в /etc/pulse/default.pa и system.pa

# ===== HINTS =====================================================================================
# mount disks:
# http://www.linuxstall.com/fstab/
#
# cinnamon + i3
# https://github.com/Gigadoc2/i3-cinnamon
#
# awoid node ENOSPC error
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# turn off show device on auto-mount
# org -> gnome -> desktop - media-handling automount-open uncheck

# Если сломались репозитории в apt
```
sudo apt --fix-broken install
sudo apt-get check
sudo apt-get update
```

# Чтобы numpad-dot всегда давал точку а не запятую -
# надо в /usr/share/X11/xkb/symbols/ru удалить вызов kpdl(comma)

# How to prevent xkbmap reset?
# --
# Edit the /etc/default/keyboard file:
# XKBLAYOUT="us,ru"
# XKBOPTIONS="grp:shift_caps_switch"

===================================================================================================
# TODO:
# 0. vim plugin for draw a hooi
# 1. 'map xp' чтобы работал как xp но не засирал регистр с copypaste
#

# How to prevent xkbmap reset?
# --
# Edit the /etc/default/keyboard file:
# XKBLAYOUT="us,ru"
# XKBOPTIONS="grp:shift_caps_switch"
