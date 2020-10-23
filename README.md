# Linux-Recycle-Bin
Command Line Recycle-Bin For Linux 

## Problem: UNIX has no recycle bin at the command line. 
When you remove a file or directory, it is gone and cannot be restored. This is program contains a recycle script and a
restore script. This will provide users with a recycle bin which can be used to safely delete and restore files

## Recycle Script
The script called recycle mimics the rm command. The recycle script accepts the name of a file as a command line argument as rm does, but instead of deleting
the file, it moves it to a recyclebin directory called recyclebin in your home directory.
- The recycle bin will be $HOME/recyclebin. The script creates this directory.
- The file to be deleted will be a command line argument and the script should be executed as follows: bash recycle fileName
- The script tests for the following error conditions and displays the same kind of error messages as the rm command.
  - No filename provided - Displays an error message if no filename is provided as an argument, and sets an error exit status.
  - File does not exist - Displays an error message if file supplied does not exist, and terminates the script.
  - Directory name provided - Displays an error message if a directory name is provided instead of a filename, and terminates the script.
  - Tests that the file being deleted is not the recycle script. If it is, displays the error message “Attempting to delete recycle – operation aborted” and terminates the script. 

The rm command can remove multiple files, for example rm file1 file2 file3. rm can also use
wildcards, for example rm file* . The rm command can use the –i option, for interactive
mode, and the –v option for verbose mode. Add this functionality to your recycle script.
The script can recycle multiple files, even if some of the files provided do not
exist. Wildcards should work as well. 
Allows the –i option. If used, prompts the user, asking for confirmation, in the same way as rm –i. A response beginning with y or Y means yes. All other responses Allows the –v option. Displays a message confirming deletion, in the same way as rm –v.
Works with both options in either order, -iv and -vi.
If an invalid option is passed into the script, displays an error message which shows the offending option value, and terminates the script with a non-zero exit status, just like the rm command.

- The filenames in the recyclebin, will be in the following format: fileName_inode
- For example, if a file named f1 with inode 1234 is recycled, the file in the recyclebin will be named f1_1234. This gets around the potential problem of deleting two files with the same name. The recyclebin will only contain files, not directories.
- Creates a hidden file called .restore.info in $HOME. Each line of this file will contain the name of the file in the recyclebin, followed by a colon, followed by the original absolute path of the file. 
- For example, if a file called f1, with an inode of 1234 was recycled from the /home/trainee1 directory, .restore.info will contain:
  - f1_1234:/home/trainee1/f1
- If another file named f1, with an inode of 5432, was recycled from the /home/trainee1/testing directory, then .restore.info will contain:
  - f1_1234:/home/trainee1/f1
  - f1_5432:/home/trainee1/testing/f1


## Restore Script
This script restores individual files back to their original location. Use the file name with inode number in order to restore the file. For example: bash restore f1_1234
- The file to be restored will be a command line argument and the script should be executed as follows: bash restore f1_1234
- This is the name of the file in $HOME/recyclebin.
- The file is restored to its original location, using the pathname stored in the .restore.info file.
- The script tests for the following error conditions and displays similar error messages to the rm command
  - No filename provided - Displays an error message if no file provided as argument,
and sets an error exit status.
  - File does not exist - Displays an error message if file supplied does not exist, and
terminates the script.
  - Checks whether the file being restored already exists in the target directory. If it does, the user will be asked “Do you want to overwrite? y/n ” The script will restore the file if the user types any word beginning with y or Y to this prompt, and not restore it if they type anything else.
- After the file has been successfully restored, the entry in the .restore.info file will be deleted.
