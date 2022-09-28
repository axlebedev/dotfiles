#!/bin/bash
argsToExclude=()
filteredArgs=()
function doFilterArgs () {
    _filteredargs=()
    allargs=("$@")
    for i in "${allargs[@]:1}"
    do
        if [[ ! " ${argsToExclude[*]} " =~ " $i " ]]; then
            _filteredargs=(${_filteredargs[@]} $i)
        fi
    done
    filteredArgs=${_filteredargs[@]}
}

if [[ $PWD == /home/l-e-b-e-d-e-v/arc* ]];
then
    # TODO: push --force
    if [[ $1 == diff ]]
    then
        argsToExclude=("--histogram" "--minimal")
        doFilterArgs $@
        eval arc diff --git "${filteredArgs[@]}"
    elif [[ $1 == commit ]]
    then
        argsToExclude=("--verbose")
        doFilterArgs $@
        eval arc commit "${filteredArgs[@]}"
    elif [[ $1 == rebase ]]
    then
        argsToExclude=("--autostash")
        doFilterArgs $@
        eval arc rebase "${filteredArgs[@]}"
    elif [[ $1 == push ]]
    then
        argsToExclude=("origin" "HEAD")
        doFilterArgs $@
        eval arc push "${filteredArgs[@]}"
    elif [[ $1 == hist ]]
    then
        argsToExclude=("--first-parent")
        doFilterArgs $@
        eval arc hist "${filteredArgs[@]}"
    else
        eval arc $@
    fi
else
    git $@
fi
