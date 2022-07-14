#!/bin/bash

get_group_members () {
	getent group "$1" | awk -F':' '{print $4}' | sed 's/,/ /g'
}

GRPS=$(cat group-list)

for g in ${GRPS[@]}; do
	getent group "$g" >/dev/null
	ret=$?

	if [[ ! $ret -eq 0 ]]; then
		echo "Missing group: $g"
		break
	fi

	read -a MMBRS <<< $(get_group_members "$g" )
	
	for m in "${MMBRS[@]}"; do
		#echo "sacctmgr -i add user \"$m\" account=\"$g\" fairshare=parent"
		echo "sacctmgr -i modify user where name=\"$m\" account=\"$g\" set maxsubmitjobs=10"
	done
done
