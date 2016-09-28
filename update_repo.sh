#!/bin/bash

msg="[AUTO-UPDATE]"
while getopts ":m:h" OPTCMD; do
    case "${OPTCMD}" in
        m) msg="${OPTARG}"
        ;;
        h) echo >&2 "update_repo [-m <commit-msg>]"
    esac 
done

git add .
git add -f *.sh

for fname in `find $PWD -maxdepth 3 -type f  -name "build_*.sh" -o -name "install_*.sh"`; do 
    git add -f $fname
done

for fname in `find $PWD -maxdepth 3 -type f  -name "gen_modules_*.sh"`; do
    git add -f $fname
done

git commit -m "$msg"
git push
git push github <<STDIN_
$(cat $HOME/.__GITHUB_TOKEN)
STDIN_
