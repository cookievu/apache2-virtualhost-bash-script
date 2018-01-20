#!/bin/bash

filePath="/etc/apache2/sites-available/"
wwwPath="/var/www/"

key=

domainPath=
publicPath=
subDomainPath=
subPublicPath=

domainName=
subDomainName=
fullSubDomainName=

echo "Hi."
echo "This code helps you quickly configure a virtual host on the linux server."
echo "......................................."
echo "Enter your domain:"
read domainName

domainPath=$wwwPath$domainName
publicPath=$domainPath"/public_html"

if [ ! -d "$wwwPath$domainName" ]; then
	echo "This domain does not exist yet"
	echo "Do you want to create this domain? [y/n]"
	read key
	if [ "$key" == "y" ]; then

		echo "Make domain dir..."
		mkdir $domainPath
		echo "Make public dir..."
		mkdir $publicPath
		sudo chown -R $USER:$USER $publicPath
		sudo chmod -R 755 $wwwPath
		FILE=$filePath$domainName".conf"

		echo "Generate configuration..."
		sudo echo "<VirtualHost *:80>" >> $FILE
		sudo echo "	ServerName  "$domainName >> $FILE
		sudo echo "	ServerAlias  www."$domainName >> $FILE
		sudo echo "	ServerAdmin admin@"$domainName >> $FILE
		sudo echo "	DocumentRoot "$publicPath >> $FILE
		sudo echo " ErrorLog " '$'{APACHE_LOG_DIR}"/error.log" >> $FILE
		sudo echo " CustomLog " '$'{APACHE_LOG_DIR}"/access.log combined" >> $FILE
		sudo echo "</VirtualHost>" >> $FILE

		echo "Define config..."
		sudo a2ensite $domainName".conf"

		echo "Restart apache..."
		sudo service apache2 restart

		echo "Done!"
	else
		echo "Ok! Goodbye."
		exit 0
	fi
else 
	echo "Found "$domainName
fi

echo "Do you want to create a subdomain? [y/n]"
read key

if [ "$key" = "y" ]; then
	echo "Enter subdomain (sub only):"
	read subDomainName

	fullSubDomainName=$subDomainName"."$domainName
	subDomainPath=$domainPath"/"subDomainName
	subPublicPath=$subDomainPath"/public_html"

	echo "Make subdomain dir..."
	mkdir $subDomainPath
	echo "Make subdomain public dir..."
	mkdir $subPublicPath
	sudo chown -R $USER:$USER $subPublicPath
	FILE=$filePath$fullSubDomainName".conf"

	echo "Generate configuration..."
	sudo echo "<VirtualHost *:80>" >> $FILE
	sudo echo "	ServerName  "$fullSubDomainName >> $FILE
	sudo echo "	ServerAlias  www."$fullSubDomainName >> $FILE
	sudo echo "	ServerAdmin admin@"$fullSubDomainName >> $FILE
	sudo echo "	DocumentRoot "$subPublicPath >> $FILE
	sudo echo " ErrorLog " '$'{APACHE_LOG_DIR}"/error.log" >> $FILE
	sudo echo " CustomLog " '$'{APACHE_LOG_DIR}"/access.log combined" >> $FILE
	sudo echo "</VirtualHost>" >> $FILE

	echo "Define config..."
	sudo a2ensite $fullSubDomainName".conf"

	echo "Restart apache..."
	sudo service apache2 restart

	echo "Done!"
else 
	echo "Ok! Goodbye."
	exit 0
fi

exit 0