#!/bin/bash

# Define ANSI color codes
GREY='\033[0;90m'
BLUE_BOLD='\033[1;34m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;36m'
NC='\033[0m' # No Color

for dir in ~/editor*; do
    if [[ -d "$dir" ]]; then
        folder_name=$(basename "$dir")

        if [[ -d "$dir/.git" ]]; then
            cd "$dir" || continue
            branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

            if [[ "$branch" == "HEAD" ]]; then
                commit=$(git rev-parse --short HEAD 2>/dev/null)
                echo -e "${GREY}$folder_name:${NC} ${BLUE}$commit${NC}"
            else
                echo -e "${GREY}$folder_name:${NC} ${BLUE_BOLD}$branch${NC}"
            fi
        else
            echo -e "${GREY}$folder_name:${NC} ${LIGHT_BLUE}Not a Git repo${NC}"
        fi
    fi
done
