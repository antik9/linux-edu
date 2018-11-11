#!/bin/bash

while :; do
	[[ ! -z $(grep "$2" $1) ]] \
		&& >&2 echo "find $2 in $1 $(date --date 'now' +'%x %X')"
	sleep 30
done;
