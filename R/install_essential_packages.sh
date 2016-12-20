#!/bin/bash

module load openmpi hdf5/1.10-cxx szlib
export LD_LIBRARY_PATH="${HDF5_ROOT}/lib:${OPENMPI_ROOT}/lib:$(brew --prefix)/lib"

_fname=$(mktemp "/tmp/__r_pkg_install.XXXXXXX.R")
touch ${_fname}


cat <<_EOF_R_PKG_ | tee -a ${_fname}
local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.r-project.org" 
       options(repos=r)
})

install.packages(c('devtools', 'glmnet'), dependencies=TRUE)
install.packages(c('Rcpp', 'RcppEigen', 'RcppArmadillo', 'RInside', 'RcppCNPy'), dependencies=TRUE)
options(unzip = 'internal')

require(devtools)
require(Rcpp)

_EOF_R_PKG_

cat <<_EOF_R_MPI_ | tee -a ${_fname}
install.packages("Rmpi", configure.args=c(
                        "LDFLAGS='-Wl,-rpath -Wl,${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib'",
                        "--with-Rmpi-type=OPENMPI", 
                        "--with-Rmpi-libpath=${OPENMPI_ROOT}/lib", 
                        "--with-Rmpi-include=${OPENMPI_ROOT}/include"))

_EOF_R_MPI_

h5_lib_flags="-Wl,-rpath=${HDF5_ROOT}/lib -L${HDF5_ROOT}/lib -Wl,-rpath=${OPENMPI_ROOT}/lib -L${OPENMPI_ROOT}/lib -Wl,-rpath=${SZLIB_ROOT}/lib -L${SZLIB_ROOT}/lib -Wl,-rpath=$(brew --prefix)/lib -L$(brew --prefix)/lib -L. -lmpi_cxx -lmpi -lhdf5_cpp -lhdf5 -lhdf5_hl -lhdf5_hl_cpp -lz -lm"
h5_inc_flags="-I${HDF5_ROOT}/include -I${OPENMPI_ROOT}/include -I$(brew --prefix)/include"

cat <<_EOF_R_H5_ | tee -a ${_fname}
install.packages('h5', configure.args=c(
                       "LIBS='${h5_lib_flags}'",
                       "CXX=mpic++",
                       "CPPFLAGS='${h5_inc_flags}'",
                       "CFLAGS='${h5_inc_flags}'"))
_EOF_R_H5_


export LD_LIBRARY_PATH="${HDF5_ROOT}/lib:${SZLIB_ROOT}/lib:${OPENMPI_ROOT}/lib:$(brew --prefix)/lib"
Rscript "${_fname}"

