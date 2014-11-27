#!/bin/bash

gcc_ver=4.8.2
gcc_type=vanilla
gcc_install_dir=$PWD/$gcc_ver/$gcc_type

echo "#%Module 1.0"
echo "#"
echo "#  gcc $gcc_ver $gcc_type"
echo "#"
echo 
echo "prepend-path PATH             $gcc_install_dir/bin"
echo "prepend-path MANPATH          $gcc_install_dir/share/man"
echo "prepend-path CPATH            $gcc_install_dir/include"
echo "prepend-path LIBRARY_PATH     $gcc_install_dir/lib64:$gcc_install_dir/lib"
echo "prepend-path LD_RUN_PATH      $gcc_install_dir/lib64:$gcc_install_dir/lib"
echo "prepend-path LD_LIBRARY_PATH  $gcc_install_dir/lib64:$gcc_install_dir/lib"
