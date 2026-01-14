# Полезные ссылки
# https://blog.gitbutler.com/git-tips-2-new-stuff-in-git/#git-maintenance
# https://git-scm.com/book/en/v2/Git-Tools-Rerere
# https://github.com/tj/git-extras/blob/main/Commands.md
#
# TODO: git-delta 
# =================================================================================================
# === LINUX INSTALL ===============================================================================
mkdir ~/github

# ----- Установка нужных программ -----
sudo add-apt-repository -y ppa:agornostal/ulauncher && \
sudo apt-add-repository ppa:fish-shell/release-4 && \
sudo add-apt-repository universe -y && \
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update

# Убрать заголовок в окне gnome-terminal
gsettings set org.gnome.Terminal.Legacy.Settings headerbar "@mb false"   
# Или в dconf-editor: org.gnome.Terminal.Legacy.Settings headerbar - uncheck "use default" - В custom ввести "False"
# menubar убрать в гуи настройках самого терминала
# После этого перелогиниться

# Добавить ключи ssh для гитхаба
ssh-keygen -t rsa -C "alexey.broadcast@gmail.com"
cat .ssh/id_rsa.pub
# Если ключ уже есть (проверить email!), то добавить его можно так
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# initial installation
# jshon \ # for clickable i3-status
# feh \ # background picture in i3
# dconf-settings \ # turn off show device on auto-mount
# ttf-ancient-fonts \ # если проблема с unicode-символами
# python3-smbc samba smbclient \ # for ya printer
# unclutter \ # скрыть курсор мыши при наборе текста
# autorandr \ # надо буудет сохранить профили
# screenkey # для показа нажатой кнопки
# linphone - для sip-телефонии. УСТАНОВИТЬ ОТДЕЛЬНО ВРУЧНУЮ!
# lxpolkit - чтобы запрашивал пароль в графических приложках
# vokoscreenNG - для записи видео скринкаста
# vlc, mpv - для просмотра .mp4
# arandr - GUI for xrandr

sudo apt install ubuntu-restricted-extras
sudo apt install -y \
git \
git-extras \
curl \
conky-all \
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
python3-smbc samba \
unclutter \
xserver-xorg-input-libinput \
screenkey \
snapd \
nodejs npm \
cmake libxkbfile-dev \
flameshot \
net-tools \
pavucontrol \
lxpolkit \
vlc \
mpv \
mailnag \
arandr \
kitty \
alacritty \
xbanish \
nodejs \
xzoom \
autorandr \
alacritty \
vokoscreen-ng \
nodejs npm \
ripgrep \
golang \
brightnessctl \
x11-utils \
arandr \
rofi \
xzoom \
tree-sitter-cli \
fd-find \
flameshot

# xkb-switch \ budet ustanovleno v razdele s vim

# set default terminal:
# sudo update-alternatives --config x-terminal-emulator

# Set kitty as default terminal:
# sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
# Verify the change:
# update-alternatives --query x-terminal-emulator | grep "Value:"

# {{{ ne delal at thinkpad
# TODO
# install git-delta manually
# https://dandavison.github.io/delta/installation.html

# Install watchman
# TODO: написать здесь как его устанавливать
# https://facebook.github.io/watchman/docs/install#ubuntu-prebuilt-debs
# }}}

# indicator-sound-switcher \ # меню звук-девайсов в трее
# gromit-mpx \ # для рисования на экране
# simplescreenrecorder \ # для записи скринкастов
sudo snap install \
diff-so-fancy \
indicator-sound-switcher \
gromit-mpx

sudo snap install --classic \
cmake \
nvim

# ----- install Chrome

# {{{ use regolith instead
# ===== I3 ================================
# https://i3wm.org/docs/repositories.html
# }}}
# ======== regolith =============
https://regolith-desktop.com/docs/using-regolith/install/

# ===== VIM =======================================================================================
# поставить галочку в Software sources -> enable source code repositories
sudo apt install -y \
liblua5.1-dev \
luajit \
libluajit-5.1-dev \
python-dev-is-python3 \
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
sudo apt-get install -y libx11-dev libxkbfile-dev
cmake ..
make && sudo make install

sudo apt build-dep vim
cd ~/github
git clone git@github.com:vim/vim.git 
cd vim/src
sudo make distclean

# TODO: пересмотреть эти флаги
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
--enable-gtk2-check 

sudo make && sudo make install

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# font here: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/ComicShannsMono

# Как установить фонты:
mkdir ~/.fonts
# Скопировать туда все нужные ttf-файлы
cp *.ttf ~/.fonts
fc-cache -f -v

# set terminal (for example alacritty)
sudo update-alternatives --config x-terminal-emulator

# ===== FISH ======================================================================================
# https://hackercodex.com/guide/install-fish-shell-mac-ubuntu/
# v gnome-terminal vmesto "chsh -s /usr/bin/fish" nado izmenit login command v nastroikah
# or-my-fish:
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bobthefish # prev: agnoster # theme
omf theme bobthefish # prev: agnoster # don't forget to enable powerline-nerd-font
# plugins TODO: первый уже не нужен, остальные 2 не работают
omf install cd
omf install sudope # TODO: разобраться и настроить
# for z: https://github.com/rupa/z/blob/master/z.sh to $path
omf install z # TODO разобраться и навешать алиасов

# ----- install i3-lock (now it is i3lock-color)
# i3lock установить в соотв. с инструкцией, всё должно собраться 
# https://github.com/Raymo111/i3lock-color

# ===== dotfiles ==================================================================================
cd ~ && \
git clone git@github.com:axlebedev/dotfiles.git && \
~/dotfiles/init.sh


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

# В ulauncher не забыть поменять хоткей, ctrl+space нужен dunst'у

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

# ===============
# Чтобы починить ubuntu-логин-скрин + убикей:
# https://bytefreaks.net/gnulinux/ubuntu-22-04lts-forces-the-use-of-yubikey-on-login-without-activating-it
#
# ==================
# Ноутбук: чтобы при наборе текста не было случайных нажатий на тачпад (+ другие настройки)
sudo add-apt-repository ppa:atareao/atareao
sudo apt update
sudo apt install touchpad-indicator

# ====================
# UNMUTE default device (bash)
# pactl set-sink-mute @DEFAULT_SINK@ toggle
#
# ================================================================================================
# Ya printer
# https://wiki.yandex-team.ru/helpdesk/secureprint/
#
# =====
# Генерация SSH ключей
# https://doc.yandex-team.ru/help/diy/common/auth/ssh-keys.html
#
# ================================================================
# Сильно шумят кулеры. Пробую решение
# На уровне железа возможно есть биндинг fn+1, кот вкл/выкл max fan
#
# ================ C++ boost ============
# https://linux.how2shout.com/how-to-install-boost-c-on-ubuntu-20-04-or-22-04/
#
# ================ i3wm audio popping
# 1. Найти имя устройства через `pacmd list-sinks`
# 2. pacmd update-sink-proplist "NAME" device.buffering.buffer_size=1048576
#
# =========================
# Почему я отказываюсь от alacritty
# 22.12.2025 на рабочем ноуте (wb thinkpad) курсор очень часто (300/сек) мигает
