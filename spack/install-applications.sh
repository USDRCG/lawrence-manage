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

# ipv6 weirdness...
#spinstall parallel

spinstall boost
spinstall jdk
spinstall r
# python 2
spinstall python
# hack for python3
spinstall python@3.6.2
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
# Commercial:
spinstall namd

# Physics
# Currently broken
# spinstall geant4
# spinstall root

# Bioinformatics
spinstall velvet
spinstall subread
#spinstall freebayes
spinstall varscan
spinstall vcftools
spinstall bamutil
spinstall bamtools
#spinstall mrbayes
spinstall mothur
spinstall phylip
spinstall picard
#spinstall tcoffee
spinstall tophat
spinstall bcftools
#spinstall bcl2fastq2
#spinstall bowtie
spinstall bowtie2
spinstall bwa
spinstall clustalo
spinstall clustalw
spinstall cufflinks
#spinstall emboss
#spinstall fastx-toolkit
spinstall fastqc
spinstall hmmer
# Commercial
#spinstall usearch
