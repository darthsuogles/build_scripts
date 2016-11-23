#!/bin/bash

source ../common.sh 
module load linuxbrew python

# To be called after the new python environment is set
toolchain='gcc'
mkl_root=${drgscl_local}/intel/mkl

pip3 install -U cython pillow psutil line_profiler

echo ">> numpy"
export LD_LIBRARY_PATH=$mkl_root/lib/intel64:$LD_LIBRARY_PATH

cat <<_MKL_EOF_ | tee numpy_site.cfg
[mkl]
library_dirs = ${mkl_root}/lib/intel64
include_dirs = ${mkl_root}/include
rpath = ${mkl_root}/lib/intel64
mkl_libs = mkl_rt
lapack_libs = 
_MKL_EOF_

(cd numpy
git pull
cp ../numpy_site.cfg site.cfg
git clean -xdf
if [[ "${toolchain}" == "intel" ]]; then
    python3 setup.py config \
	--compiler=intelem --fcompiler=intelem build_clib \
	--compiler=intelem --fcompiler=intelem build_ext \
	--compiler=intelem --fcompiler=intelem install
else
    python3 setup.py config build_clib build_ext install
fi
)

pip3 install -U scipy ipython pandas statsmodels

