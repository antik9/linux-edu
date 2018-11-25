#!/usr/bin/bash

function read_cwd_info ( ) {
    NAME=$( readlink /proc/$2/cwd )
    [ -z "$NAME" ] && return
    FD=cwd
    TYPE=DIR
    NODE=$( stat -c "%i" "$NAME" )
    SIZE=$( stat -c "%s" "$NAME" )
    [ ! $? -eq 0 ] && return
    printf "%-15.15s %-5s %-10.10s %-5.5s %-10.10s %-10s %-6.6s %s\n" \
        "$1" $2 $3 $FD $TYPE $SIZE $NODE $NAME
}

function read_root_info ( ) {
    NAME=$( readlink /proc/$2/root )
    [ -z "$NAME" ] && return
    FD=rtd
    TYPE=DIR
    NODE=$( stat -c "%i" "$NAME" )
    SIZE=$( stat -c "%s" "$NAME" )
    [ ! $? -eq 0 ] && return
    printf "%-15.15s %-5s %-10.10s %-5.5s %-10.10s %-10s %-6.6s %s\n" \
        "$1" $2 $3 $FD $TYPE $SIZE $NODE $NAME
}

function read_exe_info ( ) {
    NAME=$( readlink /proc/$2/cwd )
    [ -z "$NAME" ] && return
    FD=txt
    TYPE=REG
    NODE=$( stat -c "%i" "$NAME" )
    SIZE=$( stat -c "%s" "$NAME" )
    [ ! $? -eq 0 ] && return
    printf "%-15.15s %-5s %-10.10s %-5.5s %-10.10s %-10s %-6.6s %s\n" \
        "$1" $2 $3 $FD $TYPE $SIZE $NODE $NAME
}


function read_lsof_info ( ) {
    COMMAND=$( cat /proc/$1/comm )
    [ -z "$COMMAND" ] && return
    PID=$1
    USER=$( getent passwd $( awk '/Uid/ { print $2 }' /proc/$1/status ) | cut -d: -f1 )

    read_cwd_info   "$COMMAND" $PID $USER
    read_root_info  "$COMMAND" $PID $USER
    read_exe_info   "$COMMAND" $PID $USER
}

printf "%-15.15s %-5s %-10.10s %-5.5s %-10.10s %-10s %-6.6s %s\n" \
    COMMAND PID USER FD TYPE SIZE/OFF NODE NAME
    for file in `ls /proc | grep -E '^[[:digit:]]{1,5}$' | sort -n`; do
        read_lsof_info $file 2> /dev/null
    done
