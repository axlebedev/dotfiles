#!/bin/bash

DATE=$1
echo ${DATE}

cd ~/jsfiller3
git checkout 'develop@{'${DATE}'}'

cd ~/jsfiller3/src/modules/jsfcore
git checkout 'develop@{'${DATE}'}'

cd ~/jsfiller3/src/modules/ws-editor-lib
git checkout 'develop@{'${DATE}'}'
