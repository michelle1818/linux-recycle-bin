#!/bin/bash

# Creating $HOME/recyclebin if it's not already there
if [ ! -d ~/recyclebin ]
	then
    		mkdir ~/recyclebin
fi

# Creating a hidden file called .restore.info if it's not already there
if [ ! -f ~/.restore.info ]
  	then
    		touch ~/.restore.info
fi


####OPTIONS######
# -i is for interactive mode
# -v is for verbose mode

interactive=false
verbose=false

while getopts :iv opt
do
  	case $opt in
		i) interactive=true ;;
    		v) verbose=true ;;
		iv) interactive=true
		    verbose=true ;;
    		vi) verbose=true
        	    interactive=true ;;
		*) echo "ERROR: Invalid option $OPTARG "
		   echo "Usage: bash recycle -i | -v | -iv | -vi "
	           exit 1 ;;
	esac
done

shift $((OPTIND -1))

# Displays an error message if no filename is provided
if [ $# -eq 0 ]
  	then
    		echo "ERROR: No filename provided "
    		exit 1
else
for i in $*
do
# Displays an error message if file supplied does not exist
if [ ! -e $i ]
  	then
    		echo "ERROR: File $i does not exist "
    		continue
		exit 1
# Display an error message if a directory name is provided instead of a filename
elif [ -d $i ]
  	then
    		echo "ERROR: Directory name provided, not a file name "
    		continue
		exit 1
# Test that the file being deleted is not the recycle script
elif echo $i | grep -qw "recycle"
  	then
    		echo "ERROR: Attempting to delete recycle – operation aborted "
    		exit 1
else
# Rename file to a new file name in format fileName_inode
	name=$(basename $i)
  	inode=$(ls -i $i | cut -d " " -f1)
	fileName_inode=$name"_"$inode
# Interactive and verbose options
		if $interactive ; then
			read -p "Are you sure you want to remove file $i?: " ans
				case $ans in
					[yY]*)  ;;
					*) exit 0;;
				esac
		fi
		if $verbose ; then
			echo "File $i has been moved to recycle bin "
		fi
# Move renamed file to recycle bin
	mv $i $fileName_inode
	mv $fileName_inode ~/recyclebin

# Move renamed file with original absolute path into .restore.info
	absPath=$(readlink -m $i)
  	echo $fileName_inode:$absPath >> ~/.restore.info
fi
done
fi
