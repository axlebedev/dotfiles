# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

alias goa="~/dotfiles/fish/goa.sh"

# open 'man' in vim
set -x PAGER "/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# ======== ALIASES ========
abbr -a l ls -alF
abbr -a lr ls -lrt
# sudo apt install tree
abbr -a lt tree -a -C -I "node_modules\|.git\|bower_components"

# disc usage
# abbr -a dus du -sch .[!.]* * | sort -h

abbr -a rm rm -rf
abbr -a cp cp -r

abbr -a v gnome-terminal -- vim
abbr -a vv gvim

abbr -a o xdg-open

abbr -a ga goa add
abbr -a gas goa add src
# --verbose to show diff in vim when show commit
abbr -a gi goa commit --verbose
abbr -a gia goa commit --amend --no-edit
abbr -a giw goa commit -m "wip"

function git-sortedbranch -d 'Fuzzy-find a branch, sorted by reflog, and then all branches'
  set -l cmd (commandline -j)
  bash ~/dotfiles/fish/sortedBranch.sh |\
    fzf --no-sort -i --reverse --height=50% |\
    read -l result
  [ "$result" ]; or return
  set -l cmdResult $cmd$result | tr '\n' ' '
  commandline -j -- $cmdResult
  commandline -f repaint
end
# bind \cg git-sortedbranch
# Local branches sorted by visited

function arc-sortedbranch -d 'Fuzzy-find a branch'
  set -l cmd (commandline -j)
  bash ~/dotfiles/fish/arcSortedBranch.sh |\
    fzf --no-sort -i --reverse --height=50% |\
    read -l result
  [ "$result" ]; or return
  set -l cmdResult $cmd$result | tr '\n' ' '
  commandline -j -- $cmdResult
  commandline -f repaint
end
bind \ca arc-sortedbranch

function goa-sortedbranch -d 'git or arc sorted branch'
  if string match "/home/l-e-b-e-d-e-v/arc*" $PWD
    arc-sortedbranch
  else
    git-sortedbranch
  end
end
bind \cg goa-sortedbranch

abbr -a go goa checkout
abbr -a gr goa restore
abbr -a go goa checkout
abbr -a gob goa checkout -b
abbr -a gs goa status
# maybe git diff --patience

abbr -a gd goa diff --histogram --minimal --ignore-space-change --relative
abbr -a gdm goa diff $(goa merge-base HEAD trunk) 
abbr -a gh goa hist
abbr -a ghh goa hist --first-parent -n 10
abbr -a ghhh goa hist --first-parent -n 20
abbr -a ghhhh goa hist --first-parent -n 30
abbr -a ghs goa hist --stat --first-parent
abbr -a gpl goa pull
abbr -a gps goa push origin HEAD
abbr -a gpsu goa push -u origin HEAD
abbr -a gpsf goa push -f origin HEAD
abbr -a grb goa rebase --autostash
abbr -a grd goa rebase --autostash origin/develop
abbr -a grc goa rebase --continue
abbr -a gra goa rebase --abort
abbr -a gcp goa cherry-pick
abbr -a gcpc goa cherry-pick --continue
abbr -a gcpa goa cherry-pick --abort
abbr -a gfa goa fetch --all
abbr -a gfap goa fetch --all -p
abbr -a gb goa branch
abbr -a gbs goa bisect start
abbr -a gbr goa bisect reset
abbr -a gbg goa bisect good
abbr -a gbb goa bisect bad
abbr -a gst goa stash push --keep-index
abbr -a gsta goa stash pop
abbr -a grh goa reset HEAD^


abbr -a ah arc log --oneline
abbr -a ahh arc log --oneline -n 10
abbr -a ai arc commit
abbr -a aia arc commit --amend --no-edit
abbr -a ao arc checkout
abbr -a aob arc checkout -b
abbr -a apl arc pull
abbr -a aps arc push
abbr -a apr arc pr create
abbr -a ad arc diff
abbr -a acp arc cherry-pick
abbr -a aa arc add
abbr -a as arc status

alias showMocks='ls -1 ~/jsfiller/snfiller/static/fake-api/ | grep json'
bind mocks showMocks

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
abbr -a ysn yarn snfiller
abbr -a ycc yarn cache clean
abbr -a yi yarn --ignore-engines
