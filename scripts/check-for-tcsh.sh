#!/bin/bash

type /bin/tcsh > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo $(hostname) tcsh issue
fi
