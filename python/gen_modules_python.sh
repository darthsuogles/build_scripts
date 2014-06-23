#!/bin/bash

# This is intended to be called from the install script

echo    "#%Module 1.0"
echo    "#"
echo    "#  Python $PYTHON_VER"
echo    "#"
echo    ""
echo    "setenv         PYTHONHOME      $PYTHONHOME"
echo    "setenv         PYTHON_ARCH     $PYTHON_ARCH"
echo    "setenv         PYTHON_VER      $PYTHON_VER"
echo    "setenv         PYTHON_MKL_ROOT $PYTHON_MKL_ROOT"
echo    "prepend-path   PATH            $PYTHONHOME/bin"
echo    "prepend-path   LD_LIBRARY_PATH $PYTHONHOME/lib"
echo    "prepend-path   LD_LIBRARY_PATH $PYTHON_MKL_ROOT/lib/intel64"
echo    "prepend-path   LD_LIBRARY_PATH $PYTHON_INTEL_ROOT/lib/intel64"
echo    "prepend-path   CPATH           $PYTHONHOME/include"
echo    "prepend-path   MANPATH         $PYTHONHOME/share/man"
