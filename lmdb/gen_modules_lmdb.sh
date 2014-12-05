#!/bin/bash

source ../gen_modules.sh

print_header lmdb dev
print_modline "prepend-path LIBRARY_PATH $PWD/dev"
print_modline "prepend-path LD_LIBRARY_PATH $PWD/dev"
print_modline "prepend-path CPATH $PWD/dev"
