#!/bin/bash

source ../gen_modules.sh 
source ./sysroot.sh

#gcc_install_dir="${drgscl_local}/cellar/gcc/${gcc_ver}"
gcc_install_dir="${toolchain_install_dir}"
gcc_ver="${toolchain_ver}"

print_header gcc "${gcc_ver}"
print_modline "prepend-path PATH             $gcc_install_dir/bin"
# print_modline "prepend-path CPATH            $gcc_install_dir/include"
# print_modline "prepend-path LIBRARY_PATH     $gcc_install_dir/lib64:$gcc_install_dir/lib"
# print_modline "prepend-path LD_RUN_PATH      $gcc_install_dir/lib64:$gcc_install_dir/lib"
# print_modline "prepend-path LD_LIBRARY_PATH  $gcc_install_dir/lib64:$gcc_install_dir/lib"
print_modline "prepend-path MANPATH          $gcc_install_dir/share/man"
print_modline "prepend-path INFOPATH         $gcc_install_dir/share/info"
