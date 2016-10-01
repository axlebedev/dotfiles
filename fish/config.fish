# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# ======== ALIASES ========
# alias l="ls -alF"
# alias lr="ls -lrt"
# alias lg="l | grep -i"
# alias lrg="l -R | grep -i"
# alias lt="tree -a -C -I node_modules\|.git\|bower_components"
#
# alias v="gvim"
#
# alias o="xdg-open"
#
# alias ga="git add"
# alias gi="git commit"
# alias gia="git commit --amend --no-edit"
# alias go="git checkout"
# alias gs="git status"
# alias gd="git diff"
# alias gh="git hist"
# alias ghh="git hist -10"
# alias ghs="git hist --stat"
# alias gpl="git pull"
# alias gps="git push"
#
# alias nemo="nemo --no-desktop"
#
# alias gt="gnome-terminal"
#
# alias nd="npm run dev"
# alias nb="npm run build"
# alias nl="npm run lint"

# alias sbe="stack build && stack exec my-project-exe"

abbr -a l ls -alF
abbr -a lr ls -lrt
abbr -a lg l | grep -i
abbr -a lrg l -R | grep -i
abbr -a lt tree -a -C -I node_modules\|.git\|bower_components

abbr -a v gvim

abbr -a o xdg-open

abbr -a ga git add
abbr -a gi git commit
abbr -a gia git commit --amend --no-edit
abbr -a go git checkout
abbr -a gs git status
abbr -a gd git diff
abbr -a gh git hist
abbr -a ghh git hist -10
abbr -a ghs git hist --stat
abbr -a gpl git pull
abbr -a gps git push

abbr -a nemo nemo --no-desktop

abbr -a gt gnome-terminal

abbr -a nd npm run dev
abbr -a nb npm run build
abbr -a nl npm run lint
abbr -a nt npm run test
