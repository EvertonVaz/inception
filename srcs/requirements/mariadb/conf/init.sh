#/bin/bash
service mariadb start

mariadb -u root -e \
    "CREATE DATABASE IF NOT EXISTS ${WP_DATABASE}; \
    CREATE USER '${WP_USER}'@'%' IDENTIFIED BY '${WP_PASSWORD}'; \
    GRANT ALL ON ${WP_DATABASE}.* TO '${WP_USER}'@'%' IDENTIFIED BY '${WP_PASSWORD}'; \
    FLUSH PRIVILEGES;"