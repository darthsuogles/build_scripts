#!/bin/bash

# To be called after the new python environment is set

arch=$PYTHON_ARCH
ver=$PYTHON_VER
mkl_root=$PYTHON_MKL_ROOT

echo "installing basic packages"
./setuptools-0.6c11-py2.7.egg

echo ">> pip"
cd pip-1.2.1
python setup.py clean
python setup.py install
cd ..

pip install cython

pip install pillow
# echo ">> PIL"
# cd Imaging-1.1.7
# echo "instructions obtained from https://jamie.curle.io/blog/webfaction-installing-pil/"
# echo "modified setup.py to search jpeg, zlib and freetype"
# python setup.py clean
# python setup.py install
# cd ..

if [[ $arch == "intel" ]]; then
    module load intel
else
    module unload intel    
fi

echo ">> numpy"
export LD_LIBRARY_PATH=$mkl_root/lib/intel64:$LD_LIBRARY_PATH
cd numpy/dev
cp ../numpy_site.cfg site.cfg
python setup.py clean
if [[ $arch == "intel" ]]; then
    python setup.py config \
	--compiler=intelem --fcompiler=intelem build_clib \
	--compiler=intelem --fcompiler=intelem build_ext \
	--compiler=intelem --fcompiler=intelem install
else
    python setup.py config build_clib build_ext install
fi
cd ../..

echo ">> scipy"
cd scipy/dev
python setup.py clean
if [[ $arch == "intel" ]]; then
    python setup.py config \
	--compiler=intelem --fcompiler=intelem build_clib \
	--compiler=intelem --fcompiler=intelem build_ext \
	--compiler=intelem --fcompiler=intelem install
else
    python setup.py config build_clib build_ext install
fi
cd ../..

echo "Install the rest"
pip install ipython
pip install psutil
pip install line_profiler

