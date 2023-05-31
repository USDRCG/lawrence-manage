#!/bin/bash

SPACK_ROOT="/apps/spack"
STORAGE_HOST="zfs01"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
SNAPSHOT_NAME="storage/apps/spack@update${TIMESTAMP}"

echo
echo "Taking a ZFS snapshot of /apps/spack"
ssh $STORAGE_HOST "zfs snapshot $SNAPSHOT_NAME"
ssh $STORAGE_HOST "zfs list $SNAPSHOT_NAME"


source $SPACK_ROOT/share/spack/setup-env.sh
pkg_before=$(spack list | wc -l)
echo
echo "Updating spack"
cd $SPACK_ROOT
git stash
git pull
cd -
pkg_after=$(spack list | wc -l)

echo
echo "Re-applying spack configuration"
cp configs/*.yaml $SPACK_ROOT/etc/spack/

echo
echo "Packages available before update: " $pkg_before
echo "Packages available after  update: " $pkg_after
