#!/bin/bash

# mb.caller.sh: runs as a background process in an infinite loop calling mb.local.sh every delay seconds

delay=300 # every 5 minutes
while true; do
	./mb.local.sh
	sleep $delay
done

exit 0
