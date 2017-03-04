#!/bin/bash

# montall.sh: monitor status of every interface on local device, echo up/downs to stdout.

#IFS[]: list of interfaces to monitor
#UP[]: current UP/DOWN status of the corresponding interface in IFS[]
#RESULT[]: result of the ip link show command for the corresponding interface in IFS[]

IFS=( 'eth0_0' 'eth1_0' 'eth1_1' 'eth1_2' 'eth1_3') # maybe read these from file or args

#init UP values to true
for i in ${!IFS[@]}
do
	UP[i]=1
done


while true
do
	OUTPUT=$("ip" "link" "show")
	EXIT_STATUS=$?
	
	for i in ${!IFS[@]}
	do
		RESULT[i]="$(echo $OUTPUT | grep ${IFS[i]})"
		if [ ${UP[i]} == 1 ]; then
			# following executed if interface goes DOWN from UP state
			if [[ ${RESULT[i]} == *"DOWN"* ]]; then
				echo "$(date)"": ""${RESULT[i]}"
				UP[i]=0
			fi
		elif [ ${UP[i]} == 0 ]; then
			# following executed if interface goes UP from DOWN state
			if [[ ${RESULT[i]} == *"UP"* ]]; then
				echo "$(date)"": ""${RESULT[i]}"
				UP[i]=1
			fi
		fi

		# monitor every 5 seconds
		sleep 5
	done
done

exit 0
