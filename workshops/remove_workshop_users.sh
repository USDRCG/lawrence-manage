#!/bin/bash

source ./users.sh

# We now have two variables
# WORKSHOP_USERS - populated with emails of workshop users
# WORKSHOP_ACCOUNT - Slurm Account to add them too
ALLOWED_AD_GROUP=lawrence_allowed

function replace_domain {
	echo $1 | sed -e 's/coyotes.usd.edu/usd.local/g' -e 's/usd.edu/usd.local/g'
}
function user_in_slurm {
	#(( $(sacctmgr list user $1| wc -l) > 2 ))
	$(sacctmgr list user $1 -snP format=Account | grep -qw $WORKSHOP_ACCOUNT)
	#sacctmgr list user $1 >/dev/null; echo $?
}

LOWERCASE_USERS=("${WORKSHOP_USERS[@],,}")

# First, check for non-usd.edu users
for u in "${LOWERCASE_USERS[@]}"; do
	if [[ $u != *"usd.edu"* ]]; then
		echo "Non usd.edu user, $u, not supported in this script"
		echo "Exiting..."
		exit -1
	fi
done

# Check users already are set up in the system (in lawrence_allowed)
ALL_OK=true
for u in "${LOWERCASE_USERS[@]}"; do
	local_user=$(replace_domain $u)
	#if ! $(user_in_slurm $local_user) ; then
	if id -nG "$USER" | grep -qw "$ALLOWED_AD_GROUP"; then
		ALL_OK=false
		echo $local_user not in "$ALLOWED_AD_GROUP"
	fi
done

# Check if all users are setup
if [ "$ALL_OK" = false ]; then
	echo "These users are not in $ALLOWED_AD_GROUP, this is odd, investigate and remove manually?"
	echo "Exiting..."
	exit -1
fi

# Add all known good users
for u in "${LOWERCASE_USERS[@]}"; do
	local_user=$(replace_domain $u)
	CMD="sacctmgr -i delete user ${local_user} account=${WORKSHOP_ACCOUNT}"
	$CMD
done
