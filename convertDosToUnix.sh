#!/bin/bash
# Check-file list text file
if [[ ! $CHECK_FILE ]]
then
	CHECK_FILE="convertionFileList.txt"
fi
# Output given CHECK_FILE
printf "Reading from file: $CHECK_FILE\n"
# Check if file exists
if [[ -e "$CHECK_FILE" ]]
then 
	printf "The list file exists: $CHECK_FILE\n"
	printf "Converting text file to Unix format...\n"
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
else
	echo "Cannot find file: \$CHECK_FILE"
fi