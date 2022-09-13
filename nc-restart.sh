#!/bin/bash
if [ -n "$1" ]; then
	PROGRAM="nc -l $1"
	START='staring...'
	while true
	do
		echo -e "$PROGRAM\n$START"
		nc -l $1
		echo -e "\n\n\n"
		sleep 1
	done
else
	echo 'must be given a web port'
fi
