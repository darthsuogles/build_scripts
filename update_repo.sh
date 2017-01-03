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

pkgs=($(find $PWD -maxdepth 3 -type f \
             -name "build_*.sh" -o \
             -name "install_*.sh" -o \
             -name "README.org"))
for _i_pkg in ${pkgs[@]}; do git add -f "${_i_pkg}"; done

git commit -m "$msg"
git push
git push github <<STDIN_
$(cat $HOME/.__GITHUB_TOKEN)
STDIN_
