#!/bin/bash

# montif.sh: monitor interface status on local device, echo up/downs to stdout.

IFS=( 'eth0_0' 'eth1_0' 'eth1_1' 'eth1_2' 'eth1_3') # maybe read these from file or args
VALID_ARG=0

for i in "${IFS[@]}"
	do
		if [[ $1 == $i ]]; then
			VALID_ARG=1
		fi
	done

if [ $VALID_ARG == 0 ]; then
	echo "error: interface identifier invalid"
	exit 255
fi

UP=1
while true
	do
		RESULT=$("ip" "link" "show" "dev" "$1")
		EXIT_STATUS=$?

		if [ $UP == 1 ]; then
			if [[ $RESULT == *"DOWN"* ]]; then
				echo "$(date)"": ""$RESULT"
				UP=0
			fi
		elif [ $UP == 0 ]; then
			if [[ $RESULT == *"UP"*  ]]; then
				echo "$(date)"": ""$RESULT"
				UP=1
			fi
		fi

		sleep 5
	done

exit 0
