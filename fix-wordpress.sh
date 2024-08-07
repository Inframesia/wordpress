#!/bin/bash

# Define the new settings
NGINX_MAX_BODY_SIZE="128M"
PHP_UPLOAD_MAX_FILESIZE="128M"
PHP_POST_MAX_SIZE="128M"
PHP_MAX_EXECUTION_TIME="300"

# Update Nginx configuration
NGINX_CONF_FILE="/etc/nginx/nginx.conf"
NGINX_CONF_BACKUP="/etc/nginx/nginx.conf.bak"

# Create a backup of the current Nginx configuration file
if [ -f "$NGINX_CONF_FILE" ]; then
    sudo cp "$NGINX_CONF_FILE" "$NGINX_CONF_BACKUP"
    echo "Backup of Nginx configuration created at $NGINX_CONF_BACKUP"
fi

# Add or update the client_max_body_size directive
if grep -q "client_max_body_size" "$NGINX_CONF_FILE"; then
    sudo sed -i "s/client_max_body_size.*/client_max_body_size $NGINX_MAX_BODY_SIZE;/" "$NGINX_CONF_FILE"
else
    sudo sed -i "/http {/a \    client_max_body_size $NGINX_MAX_BODY_SIZE;" "$NGINX_CONF_FILE"
fi

# Update PHP configuration
PHP_INI_FILE="/etc/php/8.3/fpm/php.ini"
PHP_INI_BACKUP="/etc/php/8.3/fpm/php.ini.bak"

# Create a backup of the current PHP configuration file
if [ -f "$PHP_INI_FILE" ]; then
    sudo cp "$PHP_INI_FILE" "$PHP_INI_BACKUP"
    echo "Backup of PHP configuration created at $PHP_INI_BACKUP"
fi

# Update the PHP settings
sudo sed -i "s/upload_max_filesize.*/upload_max_filesize = $PHP_UPLOAD_MAX_FILESIZE/" "$PHP_INI_FILE"
sudo sed -i "s/post_max_size.*/post_max_size = $PHP_POST_MAX_SIZE/" "$PHP_INI_FILE"
sudo sed -i "s/max_execution_time.*/max_execution_time = $PHP_MAX_EXECUTION_TIME/" "$PHP_INI_FILE"

# Restart Nginx and PHP services to apply changes
sudo systemctl restart nginx
sudo systemctl restart php8.3-fpm

echo "Nginx and PHP configurations have been updated and services restarted."
