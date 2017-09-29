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

./config-spack.sh

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
