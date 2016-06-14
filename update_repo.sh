#!/bin/bash

git add .
git add -f *.sh

for fname in `find $PWD -maxdepth 3 -type f  -name "build_*.sh" -o -name "install_*.sh"`; do 
    git add -f $fname
done

for fname in `find $PWD -maxdepth 3 -type f  -name "gen_modules_*.sh"`; do
    git add -f $fname
done
