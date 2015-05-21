#!/bin/bash

# Build a package on a remote machine via ssh
script_name=$(basename ${BASH_SOURCE[0]})
build_scripts_dir=~/local/src

function quit_with()
{
    echo "Error: $@"; exit    
}

if [ $# -lt 1 ]; then
    echo "Usage: $script_name <package_name> [build options]"
    exit
fi

pkg=$1; shift
build_options=$@

pkg_dir=${build_scripts_dir}/${pkg}
ls $pkg_dir
[ -d $pkg_dir ] || quit_with "build script directory $pkg_dir cannot be found"
[ -f $pkg_dir/build_${pkg}.sh ] || quit_with "bash build script for $pkg must exist"

free_hosts=($(comm -13 <(hostname) $PBS_NODEFILE))
#echo ${free_hosts[@]}; exit

echo "Building $pkg on $free_host"
[ -z $build_options ] || echo ">> with options: ${build_options}"
ssh ${free_hosts[0]} "source ~/.chimera_envar; cd ${pkg_dir} && ./build_${pkg}.sh ${build_options} &> ${pkg_dir}/build.log" &> /dev/null &
