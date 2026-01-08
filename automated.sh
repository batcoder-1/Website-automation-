#!/bin/bash

#This script is used to setup a web project locally on a user device specifically for node app and linux distros

#Make sure before you run this script make it executable

#Variables
services=("nginx" "nodejs")
errorLog=./websetup/logs/error.log

# Taking repo url from user

read -p "Enter repo url: " repo_url

#Checking if the user has repo or not

basename=$(basename $repo_url)
repo=${basename%.*}
ls $repo &> /dev/null 

#If the user doesnt have repo. Cloning repo in users current directory
if [ $? != 0 ]
then
echo "====================================================="
echo "clonning repo in current directory"
echo "====================================================="
git clone $repo_url 2>> $errorLog
if [ $? != 0 ]
then
        echo "=============================================="
        echo "Error occured kindly look the error logs for more information"
        echo "=============================================="
        exit 1
fi
fi

# Now checking for packages and dependencies needed to be installed in order to setup it locally
for service in "${services[@]}"
do
$service -v &> /dev/null
if [ $? != 0 ] 
then
	echo "=============================================="
	echo "$service service cannot be found.Installing it..................."
	echo "=============================================="
        sudo apt install $service -y 2>> $errorLog 1> /dev/null
	if [ $? != 0 ] 	
	then
		echo "======================================="
		echo "Error occured check error logs or Please switch to root user to install it and then run script"
		echo "======================================="
		exit 1
	fi
fi
done
