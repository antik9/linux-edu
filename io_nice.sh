#!/usr/bin/bash

./writer.sh first &
first_pid=$!

./writer.sh second &
second_pid=$!

wait %1 %2

echo 'With equal io_nice'
echo $'\t' "First process took $( cat first ) seconds"
echo $'\t' "Second process took $( cat second ) seconds"

./writer.sh first &
first_pid=$!
ionice -c3 -p $first_pid

./writer.sh second &
second_pid=$!
ionice -c2 -n0 -p $second_pid

wait %1 %2

echo
echo 'With unequal io_nice'
echo $'\t' "First process took $( cat first ) seconds"
echo $'\t' "Second process took $( cat second ) seconds"
