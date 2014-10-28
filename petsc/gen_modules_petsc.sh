#!/bin/bash

echo "#%Module 1.0"
echo "#"
echo "#  PETSc and SLEPc module for use with 'environment-modules' package:"
echo "#"

echo "setenv                    PETSC_DIR	$PETSC_DIR"
echo "setenv                    PETSC_ARCH      $PETSC_ARCH"
echo "setenv                    SLEPC_DIR       $SLEPC_DIR"
echo "setenv                    TAO_DIR         $TAO_DIR"
echo "setenv                    PETSC_MAKEFILE_I    -I$PETSC_DIR/$PETSC_ARCH/include -I$PETSC_DIR/include"
echo "setenv                    PETSC_MAKEFILE_L    -L$PETSC_DIR/$PETSC_ARCH/lib"
echo "setenv                    SLEPC_MAKEFILE_I    -I$SLEPC_DIR/$PETSC_ARCH/include -I$SLEPC_DIR/include"
echo "setenv                    SLEPC_MAKEFILE_L    -L$SLEPC_DIR/$PETSC_ARCH/lib"
echo "setenv                    TAO_MAKEFILE_I      -I$TAO_DIR/include"
echo "setenv                    TAO_MAKEFILE_L      -L$TAO_DIR/$PETSC_ARCH/lib"
echo "prepend-path              PATH            $PETSC_DIR/bin:$PETSC_DIR/$PETSC_ARCH/bin"
echo "prepend-path              PATH            $SLEPC_DIR/bin"
echo "prepend-path              LD_LIBRARY_PATH      $PETSC_DIR/$PETSC_ARCH/lib"
echo "prepend-path              LD_LIBRARY_PATH      $SLEPC_DIR/$PETSC_ARCH/lib"
echo "prepend-path              LD_LIBRARY_PATH      $TAO_DIR/$PETSC_ARCH/lib"

