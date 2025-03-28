# local/bin to PATH
set -g -x PATH /usr/local/bin $PATH

# omf install bobthefish
# omf theme bobthefish
set -g theme_color_scheme light
set -g theme_nerd_fonts yes
set -g theme_date_format "+%H:%M"

alias g="~/dotfiles/fish/goa.sh"

function noy
    node ~/dotfiles/fish/noy.js | read -l command
    commandline -j -- $command
    commandline -f repaint
end
abbr -a n noy

# open 'man' in vim
set -x PAGER "/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# ======== ALIASES ========
abbr -a pp pwd
abbr -a pd pwd
# abbr -a l ls -alF
abbr -a l "pwd && ls -alF"
abbr -a lr "pwd && ls -lrt"
# sudo apt install tree
abbr -a lt "pwd && tree -a -C -I \"node_modules\|.git\|bower_components\""

# disc usage
# abbr -a dus du -sch .[!.]* * | sort -h

abbr -a rm rm -rf
abbr -a cp cp -r

abbr -a v gnome-terminal -- vim
abbr -a vv gvim

abbr -a o xdg-open

abbr -a ga g add
abbr -a gau g add -u .
abbr -a gap g add packages
# --verbose to show diff in vim when show commit
abbr -a gi g commit --verbose
abbr -a gin g commit --no-verify --verbose
abbr -a gia g commit --amend --no-verify --no-edit
abbr -a giw g commit --no-verify -m "wip"
abbr -a gil g commit --no-verify -m "linted"

function cdf
    set -l cmd (commandline -j)
    set resultPath './'
    while true
        set lslist (ls -aAF $resultPath | grep "/\$" | sort -r | string split0)
        echo $lslist | fzf --prompt="$cmd $resultPath" --layout=reverse --bind=esc:abort --height=20 --scheme=history --tac --bind esc: | tail -1 | read -l result
        if test $result
            set resultPath $resultPath$result
        else
            break
        end
    end
    commandline -j -- $cmd$resultPath
    commandline -f repaint
end
bind \ed cdf

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

function g-gobs
    set currentBranchName (git rev-parse --abbrev-ref HEAD)
    set currentBranchNameSaved (string join '' -- $currentBranchName "--saved") 
    commandline -j -- "g checkout -b $currentBranchNameSaved && g branch -D $currentBranchName"
    commandline -f repaint
end

abbr -a go g checkout
abbr -a gor g checkout users/l-e-b-e-d-e-v/
abbr -a gob g checkout -b
alias gobs g-gobs
abbr -a gbl g blame

abbr -a gs g status .
# maybe git diff --patience

function g-gh
    if string match "master" (git rev-parse --abbrev-ref HEAD)
        g hist --first-parent $argv
    else
        g hist --branches --not master $argv
    end
end

abbr -a gd g diff --histogram --minimal --ignore-space-change --relative
abbr -a gdc g diff --histogram --minimal --ignore-space-change --relative --cached
abbr -a gh g-gh
abbr -a ghh g-gh -n 10
abbr -a ghhh g-gh -n 20
abbr -a ghhhh g-gh -n 30
abbr -a ghs g-gh --stat --first-parent
abbr -a gpl g pull
abbr -a gps g push origin HEAD
abbr -a gpsu g push -u origin HEAD
abbr -a gpsf g push -f origin HEAD
abbr -a gpsfu g push -f -u origin HEAD

abbr -a grb g rebase --autostash
abbr -a grbc g rebase --continue
abbr -a grba g rebase --abort
abbr -a grbm "g fetch origin master && g rebase --autostash origin/master"

abbr -a gmm "g fetch origin master && g merge origin/master"
abbr -a gmc "g merge --continue"
abbr -a gma "g merge --abort"

abbr -a gcp g cherry-pick
abbr -a gcpc g cherry-pick --continue
abbr -a gcpa g cherry-pick --abort

abbr -a gfa g fetch --all
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

abbr -a y yarn
abbr -a yi yarn
abbr -a ys yarn start
abbr -a ysa "yarn workspace @nct/amr-demo run start & yarn workspace @nct/wte run start:amr"
abbr -a yss "yarn && yarn start"
abbr -a yb yarn build
abbr -a ybb "yarn && yarn build"
abbr -a ycc yarn cache clean
abbr -a yt yarn test
abbr -a yl yarn lint

bind ` forward-char
bind \el forward-word
bind \eh backward-kill-word

function simulate_empty_commands
    set height (tput lines)
    for i in (seq $height)
        fish_prompt
        echo
    end
    fish_prompt
end
bind \cl simulate_empty_commands


# bind \eb backward-word
# bind \ef forward-word
# bind \cw backward-kill-word

# bobthefish settings
set -g theme_display_git_default_branch yes
set -g theme_display_node yes
set -g theme_display_date no
set -g theme_display_cmd_duration yes
set -g theme_color_scheme light

alias files="xdg-open (pwd) > /dev/null 2>&1"
