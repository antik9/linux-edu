#!/usr/bin/bash

[ $# -eq 0 ] && exit 1

sleep 1
start=$( date --date 'now' +%s )

for i in `seq 1 10`; do
    dd if=/dev/zero of=$PWD/$1 bs=1M count=100 2>/dev/null
done

fin=$( date --date 'now' +%s )
echo $(( fin - start )) > $1
