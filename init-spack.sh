#!/bin/bash

SPACK_REPO="https://github.com/llnl/spack.git"
SPACK_ROOT="/apps/spack"

echo
echo "Preparing installation directory $SPACK_ROOT"
rm -rf $SPACK_ROOT/* >/dev/null 2>&1
rm -rf $SPACK_ROOT/.* >/dev/null 2>&1
rm -rf /root/.spack >/dev/null 2>&1

echo
echo "Cloning a new spack repository into $SPACK_ROOT"
git clone $SPACK_REPO $SPACK_ROOT

source $SPACK_ROOT/share/spack/setup-env.sh

echo
echo "Adding intel compiler"
module load intel

# Create /apps/spack/etc/spack/defaults/compilers.yaml
spack compiler find --scope defaults

# Prefer intel over gcc over pgi
sed -i 's/^    compiler: \[gcc, intel, pgi, clang, xl, nag\]/    compiler: \[intel, gcc, pgi, clang, xl, nag\]/g' \
	$SPACK_ROOT/etc/spack/defaults/packages.yaml

# add intel optimizations and library rpaths to config
COMPILERS="$SPACK_ROOT/etc/spack/defaults/compilers.yaml"

tac $SPACK_ROOT/etc/spack/defaults/compilers.yaml | sed -e '0,/extra_rpaths: \[\]/s//     - \/opt\/intel\/compilers_and_libraries_2017.4.196\/linux\/compiler\/lib\/intel64 \
    extra_rpaths: \ /'|tac >${COMPILERS}.new && mv ${COMPILERS}.new $COMPILERS

tac $COMPILERS | sed -e '0,/flags: {}/s//flags: \
      cflags: -O3 \
      cxxflags: -O3 \
      cppflags: -O3 \
      fflags: -O3 \
      fcflags: -O3 /' | tac >${COMPILERS}.new && mv ${COMPILERS}.new $COMPILERS

echo
echo "Configuring Modules"
sed -i "/^modules:/a\
\ \ tcl: \n \
    hash_length: 0 \n \
    naming_scheme: '\${PACKAGE}/\${VERSION}-\${COMPILERNAME}-\${COMPILERVER}' \n \
    ^r: \n \
       autoload: \'all\' \n" \
        $SPACK_ROOT/etc/spack/defaults/modules.yaml

#echo "build_jobs: 20" >> $SPACK_ROOT/etc/spack/defaults/config.yaml


echo
echo "Bootstrapping"
spack bootstrap

echo
echo "To use spack type:"
echo
echo "  source $SPACK_ROOT/share/spack/setup-env.sh"
echo

# to add to bashrc
echo
echo "To add to your .bashrc:"
echo
echo "echo export SPACK_ROOT=$SPACK_ROOT >>~/.bashrc"
echo "echo source \\\$SPACK_ROOT/share/spack/setup-env.sh >>~/.bashrc"
echo
