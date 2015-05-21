#!/bin/bash

#PBS -l walltime=8:00:00
#PBS -l nodes=1
#PBS -S /bin/bash

cd $HOME/local/src/petsc
./build_petsc.sh linux-cuda-base &> build-linux-cuda-base.log
./build_petsc.sh linux-cuda-all &> build-linux-cuda-all.log

