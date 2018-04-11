#!/bin/bash

#SPACK_ROOT=/apps/spack
SPACK_ROOT="/mnt/spack-next"
source /$SPACK_ROOT/share/spack/setup-env.sh

INSTALL="spack install"

echo "Installing applications"

module load intel

# for tar
export FORCE_UNSAFE_CONFIGURE=1


# Spack Install wrapper
spinstall () {
    echo
    echo "Installing $1"
    $INSTALL $1 
    [ $? -ne 0 ] && exit -1
}

# General
#spinstall gcc@6.3.0
#exit 0

spinstall parallel
spinstall boost
spinstall jdk
spinstall r
spinstall python@2.7.8
spinstall python@3.6.3
spinstall perl
#spinstall singularity
spinstall ffmpeg
spinstall fftw
spinstall paraview

# Physics
#spinstall root%gcc@6.3.0
#spinstall "geant4%gcc@6.3.0 -qt"       # Fails when including QT

# Chemistry
spinstall jmol
#spinstall openbabel
spinstall gromacs
spinstall lammps
#spinstall nwchem

# Bioinformatics
spinstall velvet
spinstall subread
#spinstall freebayes
spinstall varscan
spinstall vcftools
spinstall bamutil
spinstall bamtools
#spinstall mrbayes           # broken
spinstall mothur
# spinstall phylip
spinstall picard
#spinstall tcoffee           # broken, dependency ViennaRNA fails
spinstall tophat
spinstall bcftools
#spinstall bcl2fastq2        # broken, fetch fails
spinstall bowtie
spinstall bowtie2
spinstall bwa
spinstall clustalo
spinstall clustalw
spinstall cufflinks
#spinstall emboss            # broken, fetch fails
spinstall fastx-toolkit
spinstall fastqc
spinstall hmmer
#spinstall usearch           # Manual download required, put in CWD
