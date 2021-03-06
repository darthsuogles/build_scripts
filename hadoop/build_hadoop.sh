#!/bin/bash

pkg=hadoop
ver=2.7.0

# * JDK 1.7+
# * Maven 3.0 or later
# * Findbugs 1.3.9 (if running findbugs)
# * ProtocolBuffer 2.5.0
# * CMake 2.6 or newer (if compiling native code), must be 3.0 or newer on Mac
# * Zlib devel (if compiling native code)
# * openssl devel ( if compiling native hadoop-pipes and to get the best HDFS encryption performance )
# * Jansson C XML parsing library ( if compiling libwebhdfs )
# * Linux FUSE (Filesystem in Userspace) version 2.6 or above ( if compiling fuse_dfs )
# * Internet connection for first build (to fetch all Maven and Hadoop dependencies)

module load maven 
module switch protobuf/2.5.0

#url=http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-$ver/hadoop-$ver-src.tar.gz
url=http://www.interior-dsgn.com/apache/hadoop/common/hadoop-$ver/hadoop-$ver-src.tar.gz

source ../build_pkg.sh

prepare_pkg $pkg $url $ver install_dir

cd $ver
#mvn clean package -Pdist,native -DskipTests -Dtar
echo "Copying the target generated by maven"
find . -name 'target' -type d -exec mkdir -p $install_dir/{} \;
find . -name 'target' -type d -exec cp -vrT {} $install_dir/{} \;


