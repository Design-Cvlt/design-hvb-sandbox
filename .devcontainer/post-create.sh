#!/bin/bash
echo "-----> Starting Server Provisioning <-----"

# Update package lists
sudo apt-get update

# Install Apache, MariaDB (MySQL), and required PHP extensions
sudo apt-get install -y \
    apache2 \
    mariadb-server \
    php8.2-mysql

# Configure Apache Port
sudo sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf

# Configure Apache Site
sudo tee /etc/apache2/sites-available/000-default.conf > /dev/null <<EOF
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost
    DocumentRoot /workspaces/${CODESPACE_NAME}

    <Directory /workspaces/${CODESPACE_NAME}/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable PHP module and restart Apache
sudo a2enmod php8.2
sudo service apache2 restart
sudo service mariadb start

echo "-----> Provisioning Complete! Server is running. <-----"
