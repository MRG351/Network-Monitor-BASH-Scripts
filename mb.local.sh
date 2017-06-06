#!/bin/bash

pid=/tmp/mb.local.pid
#log=/var/log/mb.local.log          # /var/log is a read-only directory apparently
log=/data/home/root/mb.local.log

touch $pid
(
	unset foo
	exec {foo}< $pid
	flock -n $foo || exit 1
	
	result=$(sg-blacklist show | grep "src 0.0.0.0" | grep "dst 0.0.0.0" | head -n 1)

	if [[ -n $result ]]; then

		dev_id=$(echo "$result" | cut -d "|" -f 1)
		bl_id=$(echo "$result" | cut -d "|" -f 2)
        date=$(date +%Y-%m-%d)
		sg-blacklist iddel $dev_id $bl_id	

        log_length=$(cat $log | wc -l)

        if (( $log_length <  100 )); then 
            echo "$date: ANY-ANY blacklist removed" >> $log     
        else            
            echo "$date: ANY-ANY blacklist removed" > $log     
        fi

    fi
)

exit 0
