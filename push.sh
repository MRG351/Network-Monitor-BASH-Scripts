#!/bin/bash

# push.sh: copy file(s) to remote devices
# usage:
# 	device addresses and files can be specified through cmd line arguments or through a config file
# 	./push.sh address1:port address2:port ...  file1 file2 ... fileN (for cmd line specification)
#	./push.sh -c <conf file>  (for config file specification, file push.conf is the default selection)

# options:
#	-v: verbose mode
#   -b: abort before file copying is executed (to be used in conjunction with -v)
#	-c: specify to use a config file
#	-u: to see program usage

use_config=0
verbose=0
abort=0

user="root"
path=/home/matt/net.prog/push/
config=$path"push.conf"
config_full_path=$path
dstpath=./

set_user_with_host=0
set_dstpath_with_host=0
set_dstpath_with_file=0

args=()
hosts=()
files=()

lineno=0


# void usage(int error_status): display program usage
# side effects: exit program with error_status
function usage() {
	echo "usage: push.sh host1:port host2:port ... file1 file2 ..."
	echo "  or   push.sh -c <config file> (push.conf will be provided by default)"
    exit $1
}

# void set_usage(int error_status, perhaps the usage itself to perform resolution analysis?): display set command usage
# side effects: may exit program with error_status
# merge this with usage when you get chance, it will require checking the usage of config_error() and usage()
function set_usage() {
    echo "set: valid syntax is set x with y"
    echo "  where x = user or dstpath and y = host or file"
    echo "  eg.     set user with host"
    echo "          set dstpath with host"
    echo "          set dstpath with file"
    echo "more flexible options and syntax are on the way..."
}

# merge this with usage when you get chance, it will require checking the usage of config_error() and usage()
function host_usage() {
:    # display proper specification for host entries
}

# merge this with usage when you get chance, it will require checking the usage of config_error() and usage()
function file_usage() {
 :   # display proper specification for file entries
}

function validate_host {
   : # validate the integrity of a host entry, ip address, port, user, path etc...
     # perhaps use a c program for this purpose, I already have something like this
}

function validate_file {
    :# validate the integrity of a file entry, this is easier than the host file validation
}

function args_error() {
  :  # similar to config_error but for entries provided via cmd line
}

# void config_error(string type <1>, string file <2>, int lineno <3>, int exit <4>?): displays an error message
# side effects: may exit program depending on exit?
function config_error() {

    if [[ $1 == "file_not_found" ]]; then
        echo "configuration error: $2 not found"
        exit 1
    elif [[ $1 == "set" ]]; then
        echo "configuration error: invalid usage of 'set' in file $2 at line $3"
        # set_usage or usage "set"
        if [[ $verbose == 1 ]]; then set_usage; fi
    elif [[ $1 == "host" ]]; then
        : # WIP
        if [[ $verbose == 1 ]]; then host_usage; fi
    elif [[ $1 == "file" ]]; then
        : # WIP
        if [[ $verbose == 1 ]]; then file_usage; fi
    fi

    if [[ $4 == 1 ]]; then exit 1; fi
}

function abort() {
    echo "aborting process before file copy is executed in complience with the -b option specified at the cmd-line..."
    exit 0
}

# void verbose(string type): print program execution and config details
# side effects:   none
function verbose() {
    if [[ $1 == "args" ]]; then
        for i in ${args[@]}; do
            echo $i
        done
    elif [[ $1 == "config" ]]; then
                echo "verbose mode enabled"
        if [[ $use_config == 1 ]]; then 
                echo "config: enabled"
                echo "config file: $config"
                echo "config path: $config_full_path"
                echo "       user: set with host: ($set_user_with_host)"
# edit!         # if [[ $set_user_with_host == 1]]; loop through hosts displaying user
                echo "       user: $user"
                echo "    dstpath: set with host: ($set_dstpath_with_host)"
# edit!         # if [[ $set_dstpath_with_host == 1]]; loop through hosts displaying dstpath
                echo "    dstpath: set with file: ($set_dstpath_with_file)"
# edit!         # if [[ $set_dstpath_with_file == 1]]; loop through hosts displaying dstpath
                echo "    dstpath: $dstpath"
                echo "total lines: $lineno"

        else
                echo "config: disabled"
                echo "reading from std input..."
                echo ""
                echo "hosts: "
                for host in ${hosts[@]}; do
                    echo "    $host"
                done
                echo "files: "
                for file in ${files[@]}; do
                    echo "    $file"
                done
        fi
    elif [[ $1 == "copy" ]]; then
        echo "scp -P $port"
    fi
}

# void process_arg(string arg): processes program arguments one at a time
# side effects: verbose, use_config, args. May exit program through usage()
function process_arg() {
    if [[ $1 == -* ]]; then
# edit! # This can be improved... use special shell symbol to check for single occurance of the option letters
	    if [[ $1 == *v* ]]; then
	    	verbose=1
	    fi
	    if [[ $1 == *c* ]]; then
	    	use_config=1
	    fi
        if [[ $1 == *b* ]]; then
            abort=1
        fi
	    if [[ $1 == *u* ]]; then
		    usage 0
	    fi
    else
	    args+=("$1")
    fi
}

# void parse_conf(string config_file): parses the push configuration file
# side effects: config, config_full_path lineno, set_user_with_hosts, set_dstpath_with_host, set_dstpath_with_file, hosts, and files. May exit through config_error
function parse_config() {
   	if [[ -f $1 ]]; then
        config=$1
        config_full_path+=$config # for debugging
    else
        config_error "file_not_found" "$1" "void" 1
	fi

    while read -r line; do
        lineno=$[lineno + 1]
        if [[ $line == set* ]]; then  
            if [[ $line == *user* && $line == *host* ]]; then set_user_with_host=1;
            elif [[ $line == *dstpath* && $line == *host* ]]; then set_dstpath_with_host=1;
            elif [[ $line == *dstpath* && $line == *file* ]]; then set_dstpath_with_file=1;
            else 
                config_error "set" $1 $lineno 0
            fi
        elif [[ $line == host* ]]; then
            hosts+=("$(echo $line | awk '{print $2}')")
        elif [[ $line == file* ]]; then
            files+=("$(echo $line | awk '{print $2}')")
        else
            : # ignore all other lines
        fi
    done < $1
}

function parse_args() {
	for i in ${args[@]}; do
		if [[ -f $i ]]; then
			files+=("$i")
		else
			hosts+=("$i")
		fi
	done		
}





# main execution thread

# if no cmd-line arguments were provided, display usage and exit 1
if [[ ! -n $1 ]]; then 
    usage 1 
fi

# process cmd-line arguments one at a time
for i in $@; do 
    process_arg $i
done

# if verbose mode is enabled, display cmd-line argument information
if [[ $verbose == 1 ]]; then 
    verbose "args" 
fi


#exit 0  # test benchmark 1 - argument processing stage


# if a config file was specified, parse the config file; otherwise, parse the cmd-line arguments
if [[ $use_config == 1 ]]; then 
    parse_config ${args[0]}
else 
    for i in ${args[@]}; do 
        parse_args $i 
    done 
fi

# if verbose mode is enabled, display configuration information
if [[ $verbose == 1 ]]; then 
    verbose "config"
fi


# exit 0 # test benchmark 2 - config processing stage


# if abort mode is enabled, (cmd-line option -b), exit before file copying is executed
# perhaps move this to the loop below, put an if before the scp command and in the else place the calls to abort()
if [[ $abort == 1 ]]; then 
    abort
fi  

# copy the files to the hosts
for host in ${hosts[@]}; do

	ip=$(echo $host | cut -d ":" -f 1)
	port=$(echo $host | cut -d ":" -f 2)
	if [ $set_user_with_host == 1 ]; then
		user=$(echo $host | cut -d ":" -f 3)	
		if [ $set_dstpath_with_host == 1 ]; then
			dstpath=$(echo $host | cut -d ":" -f 4)
		fi
	else if [ $set_dstpath_with_host == 1 ]; then
		dstpath=$(echo $host | cut -d ":" -f 3)
		fi
	fi

	if [[ ! -n $ip || ! -n $port ]]; then
		echo "error: one or more host entries are invalid"
		exit 1
	fi

	for file in ${files[@]}; do     # we don't need to check for errors since the files were previously verified with -f

		if [ $set_dstpath_with_file == 1 ]; then
			dstpath=$(echo $file | cut -d ":" -f 2)
		fi

		scp "-P" $port $file $user"@"$ip":"$dstpath 
	done
done

exit 0 # test benchmark 3 - file copying stage i.e. complete program.


