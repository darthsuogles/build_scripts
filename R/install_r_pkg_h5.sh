#!/bin/bash


_fname=$(mktemp "/tmp/__r_pkg_install.XXXXXXX.R")
touch ${_fname}

cat <<_EOF_R_PKG_ | tee -a ${_fname}
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})
require(devtools)
require(Rcpp)

options(unzip = 'internal')

_EOF_R_PKG_

module load hdf5/1.10-cxx szlib openmpi
library_flags="-Wl,-rpath=${HDF5_ROOT}/lib -L${HDF5_ROOT}/lib -Wl,-rpath=${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib -Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib -Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib -L. -lmpi_cxx -lmpi -lhdf5_cpp -lhdf5 -lhdf5_hl -lhdf5_hl_cpp -lz -lm"
include_flags="-I${HDF5_ROOT}/include -I${OPENMPI_ROOT}/include -I$(brew --prefix)/include"

cat <<EOF | tee -a ${_fname}
install.packages('h5', configure.args="'LIBS=${library_flags}' 'CXX=mpic++' 'CPPFLAGS=${include_flags}' 'CFLAGS=${include_flags}'")
EOF

echo "Output fname: ${_fname}"
export LD_LIBRARY_PATH="${HDF5_ROOT}/lib:${SZLIB_ROOT}/lib:${OPENMPI_ROOT}/lib:$(brew --prefix)/lib"
Rscript ${_fname}
