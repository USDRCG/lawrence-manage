#!/bin/bash

SPACK_ROOT=/apps/spack
source /$SPACK_ROOT/share/spack/setup-env.sh

INSTALL="spack install"

echo "Installing applications"


# ipv6 weirdness...
#[ $? -eq 0 ] && $INSTALL parallel

[ $? -eq 0 ] && $INSTALL boost
[ $? -eq 0 ] && $INSTALL jdk
[ $? -eq 0 ] && $INSTALL r
[ $? -eq 0 ] && $INSTALL python@2
[ $? -eq 0 ] && $INSTALL python@3
[ $? -eq 0 ] && $INSTALL perl
[ $? -eq 0 ] && $INSTALL singularity
[ $? -eq 0 ] && $INSTALL ffmpeg
[ $? -eq 0 ] && $INSTALL fftw
[ $? -eq 0 ] && $INSTALL paraview

# Chemistry
[ $? -eq 0 ] && $INSTALL jmol
[ $? -eq 0 ] && $INSTALL openbabel
[ $? -eq 0 ] && $INSTALL gromacs
[ $? -eq 0 ] && $INSTALL lammps
[ $? -eq 0 ] && $INSTALL namd
[ $? -eq 0 ] && $INSTALL nwchem

# Physics
[ $? -eq 0 ] && $INSTALL root
[ $? -eq 0 ] && $INSTALL geant4
