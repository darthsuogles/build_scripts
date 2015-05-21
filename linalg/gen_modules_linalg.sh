#!/bin/bash

pkg=linalg
ver=0.1

INTEL_ROOT=/opt/stow/intel/composer_xe_2013_sp1.1.106

source ../gen_modules.sh

print_header $pkg $ver
print_modline "prereq openblas"
print_modline "prereq eigen"

print_modline "setenv MKLROOT $INTEL_ROOT/mkl"
print_modline "setenv TBBROOT $INTEL_ROOT/tbb"
print_modline "setenv IPPROOT $INTEL_ROOT/ipp"
print_modline "setenv OPENBLAS_ROOT $OPENBLAS_HOME"

# Printing FindLAPACK.cmake

# Printing FindBLAS.cmake
