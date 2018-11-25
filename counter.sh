#!/usr/bin/bash

[ $# -eq 0 ] && exit 1

sleep 1
start=$( date --date 'now' +%s )

result=0
for i in `seq 1 2000000`; do
    result=$(( result + i ))
done

fin=$( date --date 'now' +%s )
echo $(( fin - start )) > $1
