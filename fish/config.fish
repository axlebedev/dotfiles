# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# open 'man' in vim
set -x PAGER "/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# ======== ALIASES ========
abbr -a l ls -alF
abbr -a lr ls -lrt
abbr -a lt tree -a -C -I node_modules\|.git\|bower_components

# disc usage
# abbr -a dus du -sch .[!.]* * | sort -h

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
  bash ~/dotfiles/fish/sortedBranch.sh |\
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
abbr -a gs git switch
abbr -a gr git restore
abbr -a go git checkout
abbr -a gob git switch -c
abbr -a gss git status
# maybe git diff --patience
abbr -a gd git diff --histogram --minimal --ignore-space-change
abbr -a gh git hist
abbr -a ghh git hist --first-parent -10
abbr -a ghhh git hist --first-parent -20
abbr -a ghhhh git hist --first-parent -30
abbr -a ghs git hist --stat --first-parent
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
abbr -a gsta git stash pop
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
abbr -a ysn yarn snfiller
abbr -a ycc yarn cache clean
abbr -a yi yarn --ignore-engines

function __select_from_last
	set -l FZF_OUT (eval $history[1] | fzf)
	if test -n "$FZF_OUT"
		commandline -a "$FZF_OUT "
		commandline -f end-of-line
	end
end
bind \cn __select_from_last
