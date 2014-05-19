
ver=2.8.1

if [ ! -d $ver ]; then
    fname=freeglut-$ver
    tarball=$fname.tar.gz
    if [ ! -r $tarball ]; then
	wget http://downloads.sourceforge.net/project/freeglut/freeglut/$ver/$tarball
    fi
    fname=`tar -tzf $tarball | sed -e 's@/.*@@' | uniq`
    tar -zxvf $tarball
    mv $fname $ver
fi
