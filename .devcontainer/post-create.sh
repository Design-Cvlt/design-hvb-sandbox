#!/bin/bash

# Update package lists
sudo apt-get update

# Install Apache and PHP-MySQL extension
sudo apt-get install -y apache2 php-mysql wget unzip

# Configure Apache to run on port 8080
sudo sed -i 's/80/8080/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Change Apache's document root to our workspace folder
sudo sed -i 's|/var/www/html|/workspaces/${CODESPACE_NAME}|g' /etc/apache2/sites-available/000-default.conf
sudo a2enmod rewrite

# Start Apache
sudo service apache2 start

# Install phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
unzip phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /usr/share/phpmyadmin

# Create a config file for phpMyAdmin
sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
sudo sed -i "s/\['bz2'\]/\['bz2', 'mysqli']/" /usr/share/phpmyadmin/libraries/config.default.php
sudo ln -s /usr/share/phpmyadmin /workspaces/${CODESPACE_NAME}/phpmyadmin

echo "Setup complete. Apache is running on port 8080."
