#!/bin/bash

sleep 3

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
	--admin_user=$ADM_USER \
	--admin_password=$ADM_PASS \
	--admin_email=user@email.com

wp config set WP_DEBUG true --raw --allow-root --path=/var/www/html
wp config set WP_DEBUG_LOG true --raw --allow-root --path=/var/www/html
wp config set WP_DEBUG_DISPLAY false --raw --allow-root --path=/var/www/html
wp config set DISABLE_WP_CRON true --raw --allow-root --path=/var/www/html


php-fpm7.4 -F