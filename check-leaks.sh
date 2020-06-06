#!/bin/bash

OKGREEN='\033[92m'
ENDC='\033[0m'

if [[ "$1" != "" && -f "$1" ]] ; then
	for file in $(ls -d maps/**) ; do
		if  [ "${file: -4}" == ".cub" ] ; then
			has_leak=$(valgrind --log-fd=1 $1 $file | grep -E "(definitely lost: [1-9]+ bytes in [0-9]+ blocks|indirectly lost: [1-9]+ bytes in [0-9]+ blocks)")
			if [ "$has_leak" != "" ] ; then
				error=$(echo "$file" | grep -Eoh "[0-9]+")
				echo "leaks : $file"
				cat info | grep "$error"
			else
				printf "Test : $OKGREEN OK $ENDC\n"
			fi
		fi
	done
else
	echo "Usage: check-leaks path/to/cub3d"
fi
