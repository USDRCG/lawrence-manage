#!/bin/bash

SPACK_ROOT="/apps/spack"

# Create /apps/spack/etc/spack/defaults/compilers.yaml
module load intel
spack compiler find --scope defaults

# Prefer intel over gcc over pgi
sed -i 's/^    compiler: \[gcc, intel, pgi, clang, xl, nag\]/    compiler: \[intel, gcc, pgi, clang, xl, nag\]/g' \
        $SPACK_ROOT/etc/spack/defaults/packages.yaml

# add intel optimizations and library rpaths to config
COMPILERS="$SPACK_ROOT/etc/spack/defaults/compilers.yaml"

tac $SPACK_ROOT/etc/spack/defaults/compilers.yaml | sed -e '0,/extra_rpaths: \[\]/s//     - \/opt\/intel\/compilers_and_libraries_2017.4.196\/linux\/compiler\/lib\/intel64 \
    extra_rpaths: \ /'|tac >${COMPILERS}.new && mv ${COMPILERS}.new $COMPILERS

tac $COMPILERS | sed -e '0,/flags: {}/s//\
      cflags: -O3 \
      cxxflags: -O3 \
      cppflags: -O3 \
      fflags: -O3 \
      fcflags: -O3 \
    flags:/' | tac >${COMPILERS}.new && mv ${COMPILERS}.new $COMPILERS

echo
echo "Configuring Modules"
sed -i "/^modules:/a\
\ \ tcl: \n \
    hash_length: 0 \n \
    naming_scheme: '\${PACKAGE}/\${VERSION}' \n \
    all: \n \
      conflict: \n \
        - '\${PACKAGE}' \n \
      suffixes: \n \
        '^mkl': mkl \n \
        '^openblas': openblas \n \
        '^netlib-lapack': netlib \n \
        '^openmpi': openmpi \n \
        '^mpich': mpich \n \
    ^r: \n \
       autoload: \'all\' \n" \
        $SPACK_ROOT/etc/spack/defaults/modules.yaml

#echo "build_jobs: 20" >> $SPACK_ROOT/etc/spack/defaults/config.yaml
