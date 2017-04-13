# This is not the most current version of this file. Upload the most recent version.

#!/bin/bash

# push.sh: copy file(s) using scp to remote devices
# usage:
# 	device addresses and files can be specified through cmd line arguments or through a config file
# 	./push.sh address1:port address2:port ...  file1 file2 ... fileN (for cmd line specification)
#	./push.sh -c <conf file>  (for config file specification, file push.conf is the default selection)

# options:
#	-v: verbose mode
#	-c: specify to use a config file
#	-u: to see program usage

# WIP notes:
# put usage messages in a function usage()
# check out the getopt() library function, it can help handling arguments from the cmd line

use_config=0
verbose=0

path=/home/matt/push/
config=$path"push.conf"
dstpath=./
dstpath_set_with_host=0
dstpath_set_with_file=0
user="root"
user_set_with_host=0

args=()
hosts=()
files=()

usage1="usage: push.sh host1:port host2:port ... file1 file2 ..."
usage2="  or   push.sh -c <config file>	(push.conf will be provided by default)"


if [[ ! -n $1 ]]; then	# if no arguments are provided then exit
	echo $usage1
	echo $usage2
	#usage()
	exit 1
fi

# process arguments
for i in $@; do 
	if [[ $i == -* ]]; then
		if [[ $i == *v* ]]; then
			verbose=1
		fi
		if [[ $i == *c* ]]; then
			use_config=1
		fi
		if [[ $i == *u* ]]; then
			echo $usage1
			echo $usage2
			#usage()
			exit 0
		fi
	else
		args+=("$i")
	fi
done

if [ $use_conf == 1 ]; then
	if [[ -n "${args[0]}" && -f "${args[0]}" ]]; then
		config=$path${args[0]} # test this! $path may not be necessary since at this point the script already recognizes $2 as a valid file
	fi
fi

# WIP. Need to parse conf file or the args array and sort out host/file entries and options
if [ $use_conf == 1 ]; then
	# parse conf and store host and file entries in their respective arrays
else
	# parse args array and store ip:port's in an array and files in an array
	for i in ${args[@]}; do
		if [[ -f $i ]]; then
			files+=("$i")
		else
			hosts+=("$i")
		fi
	done		
fi

# copy the files to the hosts
for host in ${hosts[@]}; do

	ip=$(echo $host | cut -d ":" -f 1)
	port=$(echo $host | cut -d ":" -f 2)
	if [ $user_set_with_host == 1 ]; then
		user=$(echo $host | cut -d ":" -f 3)	
		if [ $dstpath_set_with_host == 1 ]; then
			dstpath=$(echo $host | cut -d ":" -f 4)
		fi
	else if [ $dstpath_set_with_host == 1 ]; then
		dstpath=$(echo $host | cut -d ":" -f 3)
		fi
	fi

	if [[ ! -n $ip || ! -n $port ]]; then
		echo "error: one or more host entries are invalid"
		exit 1
	fi

	for file in ${files[@]}; do

		if [ $dstpath_set_with_file == 1 ]; then
			dstpath=$(echo $file | cut -d ":" -f 2)
		fi

		scp "-P" $port $file $user"@"$ip":"$dstpath 
	done
done

exit 0
