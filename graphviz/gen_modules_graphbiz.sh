#!/bin/bash

ver=2.38.0

function gen_modules()
{
    echo "#%Module 1.0"
    echo "#"
    echo "# GraphViz $ver"
    echo "#"
    echo 
    echo "conflict graphviz"
    echo "prepend-path LIBRARY_PATH $PWD/$ver/lib"
    echo "prepend-path LD_LIBRARY_PATH $PWD/$ver/lib"
    echo "prepend-path PATH $PWD/$ver/bin"
    echo "prepend-path CPATH $PWD/$ver/include"
    echo "prepend-path MANPATH $PWD/$ver/share/man"
    echo "prepend-path PKG_CONFIG_PATH $PWD/$ver/lib/pkgconfig"
    echo "setenv GRAPHVIZ_EXAMPLES_DIR $PWD/ver/share/graphviz"
}

mkdir -p ~/.modulefiles/graphviz
gen_modules | tee ~/.modulefiles/graphviz/$ver
