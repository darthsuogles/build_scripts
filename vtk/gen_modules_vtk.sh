#!/bin/bash

#ver=5.8.0
ver=5.10.1
ver_major=${ver%.*}
if [ $# == 1 ]; then
    ver=`basename $1`
fi

# Check installation directory
install_dir=$PWD/$ver
if [ ! -d $install_dir ]; then
    echo "Error: $install_dir is not a valid directory"
    exit
fi

# Get the version of python
python_ver=`python --version 2>&1 | sed 's@Python\s*@@'`
python_prefix=python${python_ver%.*}

function gen_modules()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# VTK $ver"
    echo "#"
    echo 

    printf "conflict vtk\n"
    printf "setenv VTK_HOME\t $install_dir\n"
    printf "setenv VTK_VER\t $ver\n"
    if [ -d $install_dir/bin ]; then
	printf "prepend-path PATH\t $install_dir/bin\n"
    fi

    #include_dir=`find $install_dir -name '*.h' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`
    include_dir=`find $PWD/$ver -name "*.h*" | sed 's@[^/]*\.h.*@@' | sort -d | head -n 1`
    if [ ! -z "$include_dir" ]; then
	printf "prepend-path CPATH\t $include_dir\n"
    fi
    
    #static_lib_dir=(`find $install_dir -name '*.a' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`)
    #static_lib_dir=`find $PWD/$ver -name "*.a" | sed 's@[^/]*\.l?a@@' | sort -d | head -n 1`
    static_lib_dir=$install_dir/lib/vtk-$ver_major
    # if [ ! -z "$static_lib_dir" ]; then
    # 	printf "prepend-path LIBRARY_PATH\t $static_lib_dir\n"
    # fi
    printf "prepend-path LIBRARY_PATH\t $static_lib_dir\n"
    
    #dynamic_lib_dir=(`find $install_dir -name '*.so' | sed -e '1{h;d;}' -e 'G;s,\(.*\).*\n\1.*,\1,;h;$!d'`)
    #dynamic_lib_dir=`find $PWD/$ver -name "*.so" | sed 's@[^/]*\.so@@' | sort -d | head -n 1`
    dynamic_lib_dir=$install_dir/lib/vtk-$ver_major
    # if [ ! -z "$dynamic_lib_dir" ]; then
    # 	if [ "$dynamic_lib_dir" != "$static_lib_dir" ]; then
    # 	    printf "prepend-path LIBRARY_PATH\t $dynamic_lib_dir\n"
    # 	fi
    # 	printf "prepend-path LD_LIBRARY_PATH\t $dynamic_lib_dir\n"	
    # fi    
    printf "prepend-path LD_LIBRARY_PATH\t $dynamic_lib_dir\n"

    if [ -d $install_dir/plugins ]; then
	printf "prepend-path LD_LIBRARY_PATH\t $install_dir/plugins/designer\n"
    fi
    if [ -d $install_dir/lib/${python_prefix} ]; then
	printf "prepend-path PYTHONPATH\t $install_dir/lib/python2.7/site-packages/\n"
    fi
}

mkdir -p ~/.modulefiles/vtk
gen_modules | tee ~/.modulefiles/vtk/$ver
    
