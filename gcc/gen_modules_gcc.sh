#!/bin/bash

gcc_ver=${1:-5.3.0}
gcc_type=vanilla
gcc_install_dir=$PWD/$gcc_ver/$gcc_type

source ../gen_modules.sh 

gcc_install_dir="${drgscl_local}/cellar/gcc/${gcc_ver}"

print_header gcc "${gcc_ver}/${gcc_type}"
print_modline "prepend-path PATH             $gcc_install_dir/bin"
print_modline "prepend-path CPATH            $gcc_install_dir/include"
print_modline "prepend-path LIBRARY_PATH     $gcc_install_dir/lib64:$gcc_install_dir/lib"
print_modline "prepend-path LD_RUN_PATH      $gcc_install_dir/lib64:$gcc_install_dir/lib"
print_modline "prepend-path LD_LIBRARY_PATH  $gcc_install_dir/lib64:$gcc_install_dir/lib"
print_modline "prepend-path MANPATH          $gcc_install_dir/share/man"
print_modline "prepend-path INFOPATH         $gcc_install_dir/share/info"
