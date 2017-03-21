#!/bin/bash

# array indices start at 0
path=/home/matt/push/

use_conf=0
verbose=0
conf_file=""
args=()

#if [[ ! -n $1 ]]; then
#	echo "usage: ..."
#fi

for i in $@; do
	#echo $i
	if [[ $i == -* ]]; then
		if [[ $i == *v* ]]; then
			verbose=1
		fi
		if [[ $i == *c*  ]]; then
			use_conf=1
		fi
	else
		args+=("$i")
	fi
done

#if [[ ! -n "${args[0]}" ]]; then
#	echo "args[0] does not exist"
#fi

#if [[ ! -f "${args[0]}" ]]; then
#	echo "args[0] is not a valid file"
#fi

if [[ -n "${args[0]}" && -f "${args[0]}" ]]; then
	echo "args[0] dne or is nvf"
fi

#echo "use_conf = $use_conf"
#echo "verbose = $verbose"

#for i in "${args[@]}"; do
#	echo $i
#done

exit 0

if [[ ! -n $1 ]]; then
	echo "arg1 is not present"
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo "$1 is not a valid file"
	exit 1
fi

conf_file=$path$1
echo $conf_file
exit 0
