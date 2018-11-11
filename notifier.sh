#!/usr/bin/bash
# Bash script to send some stats from logs to user
[ ! $# -eq 4 ] \
    && echo "Usage ./notifier.sh <access_log_file> <error_log_file> <num_ips> <num_addreses>" \
    && exit 1;

ACCESS_LOG=$1
ERROR_LOG=$2
POP_IPS=$3
POP_ADDRS=$4
MAIL=

function popular_ips ( ) {
   awk '{ print $1 }' $1 \
       | sort \
       | uniq -c \
       | sort -rn \
       | head -$2 \
       | awk '{ print "\t", $1, "\t", $2 }'
}

function popular_addresses ( ) {
    grep -Eo "\"[[:upper:]]+ \S* " $1 \
        | awk '{ print $2 }' \
        | sort \
        | uniq -c \
        | sort -rn \
        | head -$2 \
        | awk '{ print "\t", $1, "\t", $2 }'
}

function errors ( ) {
    grep -Eo '\*[^,]*' $1 \
        | cut -d' ' -f2- \
        | sort \
        | uniq \
        | awk '{ print "\t", $0 }'
}

function status_codes ( ) {
    grep -Eo '\"[^\"]+\" [12345][[:digit:]]{2}' $1 \
        | awk '{ print $NF }' \
        | sort \
        | uniq -c \
        | awk '{ print "\t", $1, "\t", $2 }'
}

function is_between_dates ( ) {
    current_date=$(echo $1 \
        | grep -Eo '\[[^]]+' \
        | head -1 \
        | awk '{ print substr($0, 2) }' \
        | awk -F '/' '{ printf $2 " " $1 " " substr($3, 0, 4) " " substr($3, 6) }')
    date_in_seconds=`date --date "$current_date" +%s`
    [ $date_in_seconds -gt $2 -a $date_in_seconds -lt $3 ] \
        && return 0;
    return 1;
}

function is_between_dates_simple ( ) {
    current_date=$(echo $1 | cut -d' ' -f1,2)
    date_in_seconds=$(date --date "$current_date" +%s)
    [ $date_in_seconds -gt $2 -a $date_in_seconds -lt $3 ] \
        && return 0;
    return 1;
}


# Lock from multilaunch
LOCK=/var/tmp/initplock
LAST_DATE_FILE=/tmp/last_date.tmp
[ -f $LOCK ] \
    && echo Job is already running \
    && exit 2

> $LOCK
trap 'rm -f "$LOCK"; exit $?' INT TERM EXIT

# Sorting parameters for logs
last_date=$(date --date "10 years ago" +%s)
[ -f $LAST_DATE_FILE ] \
    && last_date=$(cat $LAST_DATE_FILE)
now=$(date +%s)

# Create temporary files to store needed logs by segment of time
ACCESS_LOG_TMP=$(mktemp)
ERROR_LOG_TMP=$(mktemp)
MAIL_TMP=$(mktemp)

# Filter actual dates for logs
IFS=$'\n'
for line in `cat $ACCESS_LOG`; do
    is_between_dates $line $last_date $now
    [ $? -eq 0 ] \
        && echo $line >> $ACCESS_LOG_TMP
done

for line in `cat $ERROR_LOG`; do
    is_between_dates_simple $line $last_date $now
    [ $? -eq 0 ] \
        && echo $line >> $ERROR_LOG_TMP
done

IFS=' '

# Write mail body to file
echo 'Most popular IPs:' >> $MAIL_TMP
popular_ips $ACCESS_LOG_TMP $POP_IPS >> $MAIL_TMP
echo -e '\nMost popular addreses:' >> $MAIL_TMP
popular_addresses $ACCESS_LOG_TMP $POP_ADDRS >> $MAIL_TMP
echo -e '\nFound errors:' >> $MAIL_TMP
errors $ERROR_LOG_TMP >> $MAIL_TMP
echo -e '\nStatuc codes:' >> $MAIL_TMP
status_codes $ACCESS_LOG_TMP >> $MAIL_TMP

# Send email to user
cat $MAIL_TMP \
    | mutt -s "Log updates from $(date --date "@$now" +'%x %X') to $(date --date "@$now" +'%x %X')" $MAIL

# Update last date sended to user
[ $? -eq 0 ] \
    && echo $now > $LAST_DATE_FILE

unlink $ACCESS_LOG_TMP
unlink $ERROR_LOG_TMP
unlink $MAIL_TMP
rm -f $LOCK

trap - INT TERM EXIT
