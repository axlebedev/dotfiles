#!/bin/bash

if [[ $(basename "$PWD") == "dotfiles" ]]; then
    echo "You're in dotfiles"
    exit 1
fi

