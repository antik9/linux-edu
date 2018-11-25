#!/usr/bin/bash

function get_tty ( ) {
    PTS=$(readlink /proc/$1/fd/0 | sed 's:/dev/::' | grep pts)
    [ $PTS ] && echo -n $PTS && exit 0
    TTY=$(cat /proc/$1/stat | cut -d' ' -f7)
    [ $TTY -eq 0 ] && echo -n '?' && exit 0
    echo tty$(( TTY - 1024 ))
}

function get_cmd ( ) {
    CMDLINE=$(cat /proc/$1/cmdline | strings)
    [ "$CMDLINE" ] && echo $CMDLINE | tr $'\n' ' ' && exit 0
    cat /proc/$1/comm
}

function get_stats ( ) {
    STATE=$( awk '/State/ { printf $2 }' /proc/$1/status )
    HIGH_PRIORITY=$( [ $(cat /proc/$1/stat | cut -d' ' -f19) -eq '-20' ] && echo -n '<' )
    LOW_PRIORITY=$( [ $(cat /proc/$1/stat | cut -d' ' -f19) -eq 19 ] && echo -n 'N' )
    LOCKED_PAGES=$( awk '/VmLck/ && $2 > 0 { printf "L" }' /proc/$1/status )
    SESSION_LEADER=$( \
         [ $(cat /proc/$1/stat | cut -d' ' -f1 ) -eq $(cat /proc/$1/stat | cut -d' ' -f6 ) ] \
            && echo -n 's' )
    MULTI_THREADED=$( [ $( ls /proc/$1/task | wc -l ) -gt 1 ] && echo -n 'l' )
    FOREGROUND=$( \
         [ $(cat /proc/$1/stat | cut -d' ' -f6 ) -eq $(cat /proc/$1/stat | cut -d' ' -f8 ) ] \
            && echo -n '+' )
    echo -n $STATE $HIGH_PRIORITY $LOW_PRIORITY \
        $LOCKED_PAGES $SESSION_LEADER $MULTI_THREADED \
        $FOREGROUND | sed 's/ \+//g'
}

function read_proc_info ( ) {
    PID=$1
    TTY=$(get_tty $PID)
    CMD=$(get_cmd $PID)
    STATS=$(get_stats $PID)
    [ ! $? -eq 0 ] && return
    printf "%-6s %-7s %-6s %s\n" $PID $TTY "$STATS" "$CMD"
}

for file in `ls /proc | grep -E '^[[:digit:]]{1,5}$' | sort -n`; do
    read_proc_info $file 2> /dev/null
done
