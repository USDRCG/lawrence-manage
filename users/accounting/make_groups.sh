#!/bin/bash


GRPS=$(cat group-list)

for g in ${GRPS[@]}; do
	getent group "$g" >/dev/null
	ret=$?

	if [[ $ret -eq 0 ]]; then
		echo "sacctmgr -i create account name=\"$g\" fairshare=10"
	else
		echo "Missing group: $g"
		break
	fi

done
