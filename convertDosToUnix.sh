#!/bin/bash
printf "Ensure dos2unix converter is installed in cygwin\n"
# Install dos2unix converter on vm machine
#printf "Installing dos2unix converter...\n"
#sudo yum -y install dos2unix
# Check-file list text file
if [[ ! $CHECK_FILE ]]
then
	CHECK_FILE="tempConversionFiles.txt"
fi
# Set pwd
directory=$(pwd)
# Print working directory
printf "Checking directory: $directory\n"
# Find all .sh or .txt files and store in tempConversionFiles.txt
find $directory -type f -name "*.sh" -o -name "*.txt" -o -name "*.rsp" -o -name "*.yml" > tempConversionFiles.txt
# Output given CHECK_FILE
printf "Reading from file: $CHECK_FILE\n"
# Check if file exists
if [[ -e "$CHECK_FILE" ]]
then
	printf "The list file exists: $CHECK_FILE\n"
	printf "Converting text/bash files to Unix format...\n"
	# Convert list text file to unix format
	dos2unix -o $CHECK_FILE
	# Read all files in checkfile (one per line)
	readarray checkFileList < $CHECK_FILE
	# Loop through all elements in array and perform conversion for each file
	for i in "${checkFileList[@]}"
	do
		printf "$i\n"
		dos2unix -o $i
		printf "\n"
	done 
	# Delete tempConversionFiles.txt
	rm -rf $CHECK_FILE
else
	echo "Cannot find file: \$CHECK_FILE"
fi