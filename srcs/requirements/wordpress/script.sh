#!/bin/bash

wp --allow-root config create \
	--path=/var/www/html \
	--dbname="$WP_DATABASE" \
	--dbuser="$WP_USER" \
	--dbpass="$WP_PASSWORD" \
	--dbhost=mariadb \
	--dbprefix="wp_"

wp core install --allow-root \
	--path=/var/www/html \
	--title="Inception" \
	--url=egeraldo.42.fr \
	--admin_user=$WP_USER \
	--admin_password=$WP_PASSWORD \
	--admin_email=user@email.com

echo "user: " $WP_USER

php-fpm7.4 -F