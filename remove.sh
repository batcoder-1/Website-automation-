#!/bin/bash
error_check(){
if [ $? != 0 ]
then
	echo "============================"
	echo "error occured kindly look at the log files for it"
	echo "==========================="
	exit 1
fi
}

#This script is to remove project from users current directory
project_location=$(find /home -type d -name "Website-automation-")
error_file_location=$project_location/logs/error.log
script_location=$project_location/repo.env
source  $script_location
#Removing the project from the users home directory
location=$(find /home -type d -name $repo_name)
#deleting the repo
rm -rf $location 2>> $error_file_location
error_check
echo "=================================================="
echo "Deleting the repo from home directory"
echo "=================================================="
#deleting it from /var/www/html and also its config file
if [ "$isReact" = "true" ]
then
	sudo rm -rf /var/www/html/* /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site 2>> $error_file_location 
	error_check
else
	sudo rm -rf /var/www/html/* /etc/nginx/sites-available/site /etc/nginx/sites-enabled/site 2>> $error_file_location
	error_check
fi
echo "=================================================="
echo "Deleting Configuring files"
echo "=================================================="
echo "============================"
echo "Project deleted successfully"
echo "============================"
