# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# omf install bobthefish
# omf theme bobthefish
set -g theme_color_scheme light
set -g theme_nerd_fonts yes
set -g theme_date_format "+%H:%M"

alias goa="~/dotfiles/fish/goa.sh"
alias g="~/dotfiles/fish/goa.sh"

# open 'man' in vim
set -x PAGER "/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# ======== ALIASES ========
abbr -a pp pwd
abbr -a pd pwd
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

abbr -a ga g add
abbr -a gap g add -p ./packages/callcenter-staff ./services
# --verbose to show diff in vim when show commit
abbr -a gi g commit --verbose
abbr -a gia g commit --amend --no-edit
abbr -a giw g commit -m "wip"

function cdf
    set resultPath ''
    while true
        ls -aF | grep "/\$" | fzf --layout=reverse --bind=esc:abort --height=20 --scheme=history --tac --bind esc: | tail -1 | read -l result
        if test $result
            set resultPath $resultPath$result
            echo -e '\e[1A\e[K'$resultPath
            cd $result
        else
            break
        end
    end
end
abbr -a cdf cdf

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

function g-sortedbranch -d 'git or arc sorted branch'
  if string match "/home/l-e-b-e-d-e-v/arc*" $PWD
    arc-sortedbranch
  else
    git-sortedbranch
  end
end
bind \cg g-sortedbranch

abbr -a go g checkout
abbr -a gor g checkout users/l-e-b-e-d-e-v/
abbr -a gob g checkout -b
abbr -a gbl g blame

abbr -a gs g status .
# maybe git diff --patience

abbr -a gd g diff --histogram --minimal --ignore-space-change --relative --color-words
abbr -a gdc g diff --histogram --minimal --ignore-space-change --relative --cached --color-words
abbr -a gh g hist
abbr -a ghh g hist --first-parent -n 10
abbr -a ghhh g hist --first-parent -n 20
abbr -a ghhhh g hist --first-parent -n 30
abbr -a ghs g hist --stat --first-parent
abbr -a gpl g pull
abbr -a gps g push origin HEAD
abbr -a gpsu g push -u origin HEAD
abbr -a gpsf g push -f origin HEAD
abbr -a grb g rebase --autostash
abbr -a grbt g rebase --autostash arcadia/trunk
abbr -a grbc g rebase --continue
abbr -a gra g rebase --abort
abbr -a gcp g cherry-pick
abbr -a gcpc g cherry-pick --continue
abbr -a gcpa g cherry-pick --abort
abbr -a gfa g fetch --all
abbr -a gfu g fetch users/l-e-b-e-d-e-v/
abbr -a gfap g fetch --all -p
abbr -a gb g branch
abbr -a gbs g bisect start
abbr -a gbr g bisect reset
abbr -a gbg g bisect good
abbr -a gbb g bisect bad
abbr -a gst g stash push --keep-index
abbr -a gsta g stash pop

# Почему-то остался 'g reset'. Надо защититься от него)
abbr -a gr gr

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

# alias showMocks='ls -1 ~/jsfiller/snfiller/static/fake-api/ | grep json'
# bind mocks showMocks

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

bind ` forward-char
