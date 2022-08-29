#!/bin/bash
if [[ $PWD == /home/l-e-b-e-d-e-v/arc* ]];
then
    # TODO: commit --amend --no-edit
    # TODO: push --force
    if [[ $1 == diff ]]
    then
        arc diff --ignore-space-change
    elif [[ $1 == commit ]]
    then
        arc commit
    elif [[ $1 == push ]]
    then
        arc push
    elif [[ $1 == stash ]]
    then
        arc stash
    else
        arc $@
    fi
else
    git $@
fi
