# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# ======== ALIASES ========
abbr -a l ls -alF
abbr -a lr ls -lrt
abbr -a lt tree -a -C -I node_modules\|.git\|bower_components

abbr -a rm rm -rf
abbr -a cp cp -r

abbr -a v gnome-terminal -- vim
abbr -a vv gvim

abbr -a o xdg-open

abbr -a ga git add
abbr -a gas git add src
abbr -a gap git add packages
# --verbose to show diff in vim when show commit
abbr -a gi git commit --verbose
abbr -a gia git commit --amend --no-edit
abbr -a giw git commit -m "wip"

function git-sortedbranch -d 'Fuzzy-find a branch, sorted by reflog, and then all branches'
  set -l cmd (commandline -j)
  [ "$cmd" ]; or return
  eval bash ~/dotfiles/fish/sortedBranch.sh |\
    fzf --no-sort -i --reverse --height=50% |\
    read -l result
  [ "$result" ]; or return
  set -l cmdResult $cmd$result | tr '\n' ' '
  commandline -j -- $cmdResult
  commandline -f repaint
end
bind \cg git-sortedbranch
# Local branches sorted by visited

function git-commit -d 'Fuzzy-find a commit'
  set -l cmd (commandline -j)
  [ "$cmd" ]; or return
  eval $cmd |\
    eval git hist |\
    grep -v HEAD |\
    string trim |\
    awk '!x[$0]++' |\
    fzf --ansi -i --height=50% --reverse --no-sort |\
    read -l result
  [ "$result" ]; or return
  set -l $result (echo $result | sed -r 's/^.*([0-9a-f]{7}).*$/\1/')
  set -l cmdResult $cmd$result | tr '\n' ' '
  commandline -j -- $cmdResult
  commandline -f repaint
end
bind \cb git-commit

abbr -a go git checkout

abbr -a gob git checkout -b
abbr -a gos git checkout src
abbr -a gop git checkout packages
abbr -a god git checkout develop
abbr -a gs git status
# maybe git diff --patience
abbr -a gd git diff --histogram --minimal --ignore-space-change
abbr -a gh git hist
abbr -a ghh git hist -10
abbr -a ghhh git hist -20
abbr -a ghhhh git hist -30
abbr -a ghs git hist --stat
abbr -a gpl git pull
abbr -a gps git push origin HEAD
abbr -a gpsu git push -u origin HEAD
abbr -a gpsf git push -f origin HEAD
abbr -a gr git rebase --autostash
abbr -a grd git rebase --autostash origin/develop
abbr -a grc git rebase --continue
abbr -a gra git rebase --abort
abbr -a gcp git cherry-pick
abbr -a gcpc git cherry-pick --continue
abbr -a gcpa git cherry-pick --abort
abbr -a gfa git fetch --all
abbr -a gfap git fetch --all -p
abbr -a gbs git bisect start
abbr -a gbr git bisect reset
abbr -a gbg git bisect good
abbr -a gbb git bisect bad
abbr -a gst git stash save --keep-index
abbr -a gsta git stash apply
abbr -a grh git reset HEAD^

alias copyBranch="git rev-parse --abbrev-ref HEAD | xclip -sel clip"
abbr -a cb copyBranch

abbr -a nemo nemo --no-desktop

abbr -a gt gnome-terminal

abbr -a ni npm i
abbr -a nis npm i --save
abbr -a ncc npm cache clean -f
abbr -a nb npm run build
abbr -a ns npm start
abbr -a nl npm run lint
abbr -a nt npm run test
abbr -a nta npm run test-all

abbr -a ys yarn start
abbr -a ycc yarn cache clean
abbr -a yi yarn --ignore-engines
