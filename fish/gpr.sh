#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)
url=$(git remote get-url origin)
# git@gitlab.stageoffice.ru:spb-web/wte/editor.git

url=${url/"git@"/""}
url=${url/".git"/""}
url=${url/":"/"/"}

echo "https://$url/-/merge_requests/new?merge_request%5Bsource_branch%5D=$branch"
eval "google-chrome --user-data-dir=/home/lebedev.aleksey101/chrome-users/wildberries https://$url/-/merge_requests/new?merge_request%5Bsource_branch%5D=$branch"
