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
		id "$m" >/dev/null
		ret=$?
		if [[ ! $ret -eq 0 ]]; then
			echo "Strange error, user $m not found, but is in group $g"
		fi
	done
done
