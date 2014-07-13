#!/bin/bash

ver=2.38.0-1
rhel_ver=`uname -a | perl -ne 'if ($_ =~ /\.(el\d)/) { print "$1" }'`

fname=graphviz-$ver.$rhel_ver.x86_64.rpm
url=http://www.graphviz.org/pub/graphviz/stable/redhat/$rhel_ver/x86_64/os/$fname

echo $url

rpm2cpio $fname | cpio -idmv
