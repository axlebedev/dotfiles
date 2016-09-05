# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# ======== ALIASES ========
alias l="ls -alF"
alias lr="ls -lrt"
alias lg="l | grep -i"
alias lrg="l -R | grep -i"
alias lt="tree -a -C -I node_modules\|.git\|bower_components"

alias v="gvim"

alias o="xdg-open"

alias ga="git add"
alias gi="git commit"
alias gia="git commit --amend --no-edit"
alias go="git checkout"
alias gs="git status"
alias gd="git diff"
alias gh="git hist"
alias ghh="git hist -10"
alias ghs="git hist --stat"
alias gpl="git pull"
alias gps="git push"

alias nemo="nemo --no-desktop"

alias gt="gnome-terminal"

alias nd="npm run dev"
alias nb="npm run build"
alias nl="npm run lint"

# alias sbe="stack build && stack exec my-project-exe"
