#!/bin/bash

USERNAME="$1"

if [ -z "$USERNAME" ]; then
  echo 
  echo "ERROR"
  echo "Must supply user name"
  exit 1
  echo 
fi

DIR="/home/usd.local/$USERNAME"


if [ ! -d $DIR ]; then
  echo 
  echo "ERROR"
  echo "$DIR does not exist"
  echo 
  exit 1
fi

if [ $(ssh zfs01 zfs list $DIR | tail -1 | awk '{print $5}') != "/storage/home" ]; then
  echo 
  echo "ERROR"
  echo "$DIR is already a ZFS filesystem"
  echo 
  ssh zfs01 zfs list $DIR
  echo
  exit 1
fi

echo
echo "Migrating $DIR to new ZFS filesystem"

mv $DIR $DIR.old
if [ $? -ne "0" ]; then
  echo 
  echo "ERROR"
  echo "Error moving $DIR to $DIR.old"
  echo 
  exit 1
fi
  
echo "Creating new zfs filesystem"
/opt/manage/users/setup_homedir $USERNAME

echo "Migrating files"
tar -C $DIR.old -cf - . | tar -C $DIR -xf -
echo

echo "Done"
exit 0
