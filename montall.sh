#!/bin/bash

# montall.sh: monitor status of every interface on local device, echo up/downs to stdout.

IFS=( 'eth0_0' 'eth1_0' 'eth1_1' 'eth1_2' 'eth1_3') # maybe read these from file or args

#init UP values
for i in {0..4}
do
	UP[i]=1
done


while true
do
	RESULT=$("ip" "link" "show")
	EXIT_STATUS=$?
	
	for i in {0..4}
	do
		R[i]="$(echo $RESULT | grep ${IFS[i]})"
		if [ ${UP[i]} == 1 ]; then
			if [[ ${R[i]} == *"DOWN"* ]]; then
				echo "$(date)"": ""${R[i]}"
				UP[i]=0
			fi
		elif [ ${UP[i]} == 0 ]; then
			if [[ ${R[i]} == *"UP"* ]]; then
				echo "$(date)"": ""${R[i]}"
				UP[i]=1
			fi
		fi

		sleep 5
	done
done

exit 0
