#!/bin/bash

SPACK_ROOT=/apps/spack
source /$SPACK_ROOT/share/spack/setup-env.sh

INSTALL="spack install"

echo "Installing applications"

# for tar
export FORCE_UNSAFE_CONFIGURE=1


# Spack Install wrapper
spinstall () {
    echo
    echo "Installing $1"
    $INSTALL $1
    [ $? -ne 0 ] && exit -1
}

spinstall parallel
spinstall boost
spinstall jdk
spinstall r
spinstall python       # python 2
spinstall python@3.6.2 # hack for python3
spinstall perl
spinstall singularity
spinstall ffmpeg
spinstall fftw
spinstall paraview

# Chemistry
spinstall jmol
spinstall openbabel
spinstall gromacs
spinstall lammps
spinstall nwchem

# Physics
spinstall gcc@6.3.0 %gcc
spinstall root %gcc@6.3.0
spinstall geant4 %gcc@6.3.0

# Bioinformatics
spinstall velvet
spinstall subread
spinstall freebayes %gcc   # won't build with intel
spinstall varscan
spinstall vcftools
spinstall bamutil
spinstall bamtools
#spinstall mrbayes     # broken
spinstall mothur
spinstall phylip
spinstall picard
#spinstall tcoffee     # broken
spinstall tophat
spinstall bcftools
#spinstall bcl2fastq2  # broken
#spinstall bowtie      # broken
spinstall bowtie2
spinstall bwa
spinstall clustalo
spinstall clustalw
spinstall cufflinks
#spinstall emboss      # broken
#spinstall fastx-toolkit # broken
spinstall fastqc
spinstall hmmer
#spinstall usearch # Manual download required, put in CWD
