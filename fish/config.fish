# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# ======== ALIASES ========
# alias sbe="stack build && stack exec my-project-exe"

abbr -a l ls -alF
abbr -a lr ls -lrt
abbr -a lg l | grep -i
abbr -a lrg l -R | grep -i
abbr -a lt tree -a -C -I node_modules\|.git\|bower_components

abbr -a rm rm -rf
abbr -a cp cp -r

abbr -a v gvim

abbr -a o xdg-open

abbr -a ga git add
abbr -a gas git add src
abbr -a gi git commit
abbr -a gia git commit --amend --no-edit
abbr -a giw git commit -m "wip"
abbr -a go git checkout
abbr -a gos git checkout src
abbr -a god git checkout develop
abbr -a gs git status
abbr -a gd git diff
abbr -a gh git hist
abbr -a ghh git hist -10
abbr -a ghs git hist --stat
abbr -a gpl git pull
abbr -a gps git push
abbr -a grd git rebase origin/develop
abbr -a gfa git fetch --all
abbr -a gfap git fetch --all -p

abbr -a nemo nemo --no-desktop

abbr -a gt gnome-terminal

abbr -a nd sudo npm run dev
abbr -a nb npm run build
abbr -a nl npm run lint
abbr -a nt npm run test

abbr -a est es-ctags -R .
