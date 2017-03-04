#!/bin/bash

# montif.sh: monitor interface status on local device, echo up/downs to stdout.

IFS=( 'eth0_0' 'eth1_0' 'eth1_1' 'eth1_2' 'eth1_3') # maybe read these from file or args
VALID_ARG=0

# check that program argument matches one of the valid interface identifiers above
for i in "${IFS[@]}"
	do
		if [[ $1 == $i ]]; then
			VALID_ARG=1
		fi
	done

# if argument doesn't match a valid interface identifier, exit with an error
if [ $VALID_ARG == 0 ]; then
	echo "error: interface identifier invalid"
	exit 255
fi

UP=1 # assume interface is UP at program start
while true
	do
		OUTPUT=$("ip" "link" "show" "dev" "$1")
		EXIT_STATUS=$?

		# following is executed if interface goes DOWN from UP
		if [ $UP == 1 ]; then
			if [[ $OUTPUT == *"DOWN"* ]]; then
				echo "$(date)"": ""$OUTPUT"
				UP=0
			fi
		elif [ $UP == 0 ]; then
			# following is executed if interface goes UP from DOWN
			if [[ $OUTPUT == *"UP"*  ]]; then
				echo "$(date)"": ""$OUTPUT"
				UP=1
			fi
		fi

		sleep 5 # monitor interface every 5 seconds
	done

exit 0
