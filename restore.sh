#!/bin/bash

# Function to restore the file to original location
function restoreFile {

# Get absolute path from .restore.info
	pathName=$(grep $1 ~/.restore.info | cut -d ":" -f2)

# Check if file being restored already exists in the target directory
	if [ -e $pathName ]
  		then
    			read -p "Do you want to overwrite? y/n " ans
    			case $ans in
      				[yY]*)
        				rm $pathName
       	 				mv ~/recyclebin/$1 $pathName
        				echo "File $1 has been restored "
					# After file is restored, restore.info entry is deleted
        				sed -e "/$1/d" ~/.restore.info > ~/.restore2.info
        				mv ~/.restore2.info ~/.restore.info ;;
      				*) echo "File $1 will not be restored"
                    		exit 0 ;;
	  		esac
	else
        	mv ~/recyclebin/$1 $pathName
        	echo "File $1 has been restored "
        	# After file is restored, restore.info entry is deleted
        	sed -e "/$1/d" ~/.restore.info > ~/.restore.info2
        	mv ~/.restore.info2 ~/.restore.info
	fi
}

# Displays an error message if no filename is provided
if [ $# -eq 0 ]
  	then
    		echo "ERROR: No filename provided "
    		exit 1
# Displays an error message if file supplied does not exist
elif [ ! -e ~/recyclebin/$1 ]
	then
    		echo "ERROR: File $1 does not exist "
    		exit 1
# Call restoreFile function if file exists in recycle bin
else
	restoreFile $1
fi
