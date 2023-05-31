#!/bin/bash

########################## WARNING ##################################
# You need to fill in this variable with the lab folder name for this
# to work.
#####################################################################

_LAB_NAME=""

# Build new prefix paths because we will want to check if they exist
          _MY_PREFIX="/home"
           _LAB_PATH="${_MY_PREFIX}/${_LAB_NAME}/software/bin"
   _LAB_LIBRARY_PATH="${_MY_PREFIX}/${_LAB_NAME}/software/lib"
_LAB_LD_LIBRARY_PATH="${_MY_PREFIX}/${_LAB_NAME}/software/lib"
          _LAB_CPATH="${_MY_PREFIX}/${_LAB_NAME}/software/include"
     _LAB_MODULEPATH="${_MY_PREFIX}/${_LAB_NAME}/software/modulefiles"


# Check if the paths exist and if they do add Lab's software to
#  user's paths so they can use the software
if [ -d "$_LAB_PATH" ]; then
	export PATH="$_LAB_PATH:$PATH"
fi
if [ -d "$_LAB_LIBRARY_PATH" ]; then
	export LIBRARY_PATH="$_LAB_LIBRARY_PATH:$LIBRARY_PATH"
fi
if [ -d "$_LAB_LD_LIBRARY_PATH" ]; then
	export LD_LIBRARY_PATH="$_LAB_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
fi
if [ -d "$_LAB_CPATH" ]; then
	export CPATH="$_LAB_CPATH:$CPATH"
fi
if [ -d "$_LAB_MODULEPATH" ]; then
	export MODULEPATH="$_LAB_MODULEPATH:$MODULEPATH"
fi
