#!/bin/bash

#This script is used to setup a web project locally on a user device specifically for simple frontend project and linux distros

#Make sure before you run this script make it executable

#functions

error_check(){
if [ $? != 0 ]
then
        echo "=============================================="
        echo "Error occured kindly look the error logs for more information"
        echo "=============================================="
        exit 1
fi
}

#Variables
services=("nginx" "nodejs")
scriptD=$(find /home -type d -name "Website-automation-")
errorLog=$scriptD/logs/error.log
isReact=false
# Taking repo url from user

read -p "Enter repo url: " repo_url

#Checking if the user has repo or not

basename=$(basename $repo_url)
repo=${basename%.*}
ls $repo 2> /dev/null
#If the user doesnt have repo. Cloning repo in users current directory
if [ $? != 0 ]
then
echo "====================================================="
echo "clonning repo in current directory"
echo "====================================================="
git clone $repo_url 2>> $errorLog
error_check
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
	if [ $service == "nodejs" ]
	then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash 2>> $errorlog > /dev/null
		\. "$HOME/.nvm/nvm.sh"
		nvm install --lts 2>> $errorLog > /dev/null
	else 
		sudo apt install $service -y 2>> $errorLog 1> /dev/null
	fi
	error_check
fi
done
# now checking if the project include react or not for which we have to build before deploy

ls $repo/package.json &> /dev/null
if [ $? == 0 ]
then 
	isReact=true
	cd $repo
	npm install 2>> $errorLog 1> /dev/null
	error_check
	# changing the base to / in vite config.js to avoide any mismatch with the nginx conf file 
	sed -i "s|^ *base:.*|  base: '/',|g" vite.config.js
	# now building the repo
       	echo "==========================================================="
	echo "Building for deployment"
	echo "==========================================================="	
	npm run build 2>> $errorLog 1> /dev/null
	error_check
	cd ..
fi
if [ "$isReact" = "true" ]
then
	# copying project in /var/www/html
	sudo cp -r $repo/dist /var/www/html
	error_check
	# Now making config files for it 
	sudo touch /etc/nginx/sites-available/site
	error_check
	sudo tee /etc/nginx/sites-available/site > /dev/null <<EOF
	server {
    	listen 80;
    	listen [::]:80;

    	server_name example.com;

    	root /var/www/html/dist;
    	index index.html;

    	location / {
        try_files \$uri \$uri/ /index.html =404;
    	}
	}
EOF
error_check
else
	# copying project in /var/www/html
	sudo cp -r $repo /var/www/html
	error_check
	# Now making config files for it 
	sudo touch /etc/nginx/sites-available/site
	error_check	
	sudo tee /etc/nginx/sites-available/site > /dev/null <<EOF
	server {
    	listen 80;
    	listen [::]:80;

    	server_name example.com;

    	root /var/www/html/$repo;
    	index index.html;

    	location / {
        try_files \$uri \$uri/ =404;
    	}
	}
EOF
error_check
fi
# changing ownership of var/www/html so that nginx can access it 
sudo chown -R www-data:www-data /var/www/html

#Now enabling it 
sudo ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled
error_check
sudo systemctl reload nginx.service
error_check

#before executing storing important details in env for further use 

cat > ./Website-automation-/repo.env <<EOF
repo_name="$repo"
isReact="$isReact"
EOF
echo "=============================================================="
echo "Site successfully depoyed locally you can check on localhost:80"
echo "=============================================================="
