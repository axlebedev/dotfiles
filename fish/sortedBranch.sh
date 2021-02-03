#!/bin/bash

# allBranches=""
# while read -r line 
# do
#     allBranches=$"${allBranches}\n${line}"
# done < $(git branch --all |\
#     grep -v HEAD |\
#     sed -r 's/(remotes\/)(origin\/)(.*)/\2\3\n\3/' |\
#     sed -r 's/\* //')
# # printf "%s" $allBranches

allBranches="$(git branch --all |\
    grep -v HEAD |\
    sed -r 's/( *remotes\/)(origin\/)(.*)/\2\3\n\3/' |\
    sed -r 's/\* //')"

localBranches="$(git log -g --grep-reflog "checkout:" --format="%gs" |\
    cat -n |\
    sed -E "s/^\s+([0-9]+).*from (.*) to .*/\2/g" |\
    grep -v --regexp="[0-9a-f]\{40\}\$")"
printf "$localBranches \n $allBranches" | sed -r 's/^ *(.*) *$/\1/' | awk '!x[$0]++'

# printf "%s%s" $localBranches $allBranches | fzf --no-sort -i --reverse --height=50%
