#/bin/bash
service mariadb start

mariadb -u root -e \
    "CREATE DATABASE IF NOT EXISTS ${WP_DATABASE}; \
    CREATE USER '${WP_USER}'@'%' IDENTIFIED BY '${WP_PASSWORD}'; \
    GRANT ALL ON ${WP_DATABASE}.* TO '${ADM_USER}'@'%' IDENTIFIED BY '${ADM_PASS}'; \
    FLUSH PRIVILEGES;"