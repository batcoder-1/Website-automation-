#!/bin/bash

#This script is used to setup a web project locally on a user device specifically for node app and linux distros

#Make sure before you run this script make it executable

#Variables
services=nginx
errorLog=./websetup/logs/error.log

# Now checking for packages and dependencies needed to be installed in order to setup it locally

systemctl list-units --type=service | grep "nginx" 2>> $errorLog 
if [ $? != 0 ] 
then
	echo "=============================================="
	echo "Nginx service cannot be found.Installing it..................."
        sudo apt install nginx 2>> $errorLog
	if [ $? != 0 ] 	
	then
		echo "======================================="
		echo "Please switch to root user to install it and then run script"
	fi

# Clonnig repo in users current directory

echo "==================================="
echo "clonning repo in current directory"
git clone $repo_url 2>> $errorLog
if [ $? != 0 ]
then
        echo "=============================================="
        echo "Error occured kindly look the error logs for more information"
fi

