#!/usr/bin/bash

taskset -c 0 ./counter.sh first &
first_pid=$!

taskset -c 0 ./counter.sh second &
second_pid=$!

sleep 3
echo 'Processes cpu usage:'
ps aux --sort=%cpu | grep counter | grep -v grep
echo

wait %1 %2

echo 'With equal nice'
echo $'\t' "First process took $( cat first ) seconds"
echo $'\t' "Second process took $( cat second ) seconds"
echo

taskset -c 0 ./counter.sh first &
first_pid=$!
renice -n -10 -p $first_pid

taskset -c 0 ./counter.sh second &
second_pid=$!
renice -n 10 -p $second_pid
echo

sleep 3
echo 'Processes cpu usage:'
ps aux --sort=%cpu | grep counter | grep -v grep
echo

wait %1 %2

echo 'With unequal nice'
echo $'\t' "First process took $( cat first ) seconds"
echo $'\t' "Second process took $( cat second ) seconds"
