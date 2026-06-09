#!/bin/bash

allBranches="$(arc branch -a |\
    grep -v HEAD |\
    sed -r 's/\* //')"
printf "$allBranches" | sed -r 's/^ *(.*) *$/\1/' | awk '!x[$0]++'

localBranches="$(arc branch -a |\
 cat -n |\
 grep -E "moving|renamed" |\
 grep -v "to trunk" |\
 sed -r 's/.*to (.*)/\1/' |\
 grep -v -E '^[a-f0-9]{40}$')"
# printf "$localBranches" | sed -r 's/^ *(.*) *$/\1/' | awk '!x[$0]++'

printf "%s%s" $localBranches | sed -r 's/^ *(.*) *$/\1/' | awk '!x[$0]++'
