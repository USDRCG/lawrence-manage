#!/bin/bash

SPACK_ROOT="/apps/spack"

echo
echo "Configuring Compilers"
# Create /apps/spack/etc/spack/defaults/compilers.yaml
module load intel
spack compiler find --scope defaults
COMPILERS="$SPACK_ROOT/etc/spack/defaults/compilers.yaml"

# add intel optimizations and library rpaths to config
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
echo "Configuring Packages"
PACKAGES="$SPACK_ROOT/etc/spack/defaults/packages.yaml"
# Prefer intel over gcc over pgi
sed -i 's/^    compiler: \[gcc, intel, pgi, clang, xl, nag\]/    compiler: \[intel, gcc, pgi, clang, xl, nag\]/g' \
        $PACKAGES
sed -i 's/blas: \[openblas\]/blas: \[intel-mkl\]/g' \
        $PACKAGES
sed -i 's/lapack: \[openblas\]/lapack: \[intel-mkl\]/g' \
        $PACKAGES
sed -i 's/scalapack: \[netlib-scalapack\]/scalapack: \[intel-mkl\]/g' \
        $PACKAGES

echo
echo "Configuring Modules"
MODULES="$SPACK_ROOT/etc/spack/defaults/modules.yaml"
# Customize module names
sed -i "/^modules:/a\
\ \ tcl: \n \
      whitelist: \n \
        - 'geant4' \n \
        - 'root' \n \
      blacklist: \n \
        - '%gcc' \n \
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
        $MODULES

#echo "build_jobs: 20" >> $SPACK_ROOT/etc/spack/defaults/config.yaml
