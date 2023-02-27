#!/bin/bash
echo 'Configuring wp-config.php. ...'
cp /app/wp-config-sample.php /app/wp-config.php

MARIADB_USER_PASSWORD=$(cat $MARIADB_USER_PASSWORD_FILE)
sed -i "s/define\s*(\s*'DB_NAME'\s*,.*);/define( 'DB_NAME', '$MARIADB_DATABASE' );/g" /app/wp-config.php
sed -i "s/define\s*(\s*'DB_USER'\s*,.*);/define( 'DB_USER', '$MARIADB_USER' );/g" /app/wp-config.php
sed -i "s/define\s*(\s*'DB_PASSWORD'\s*,.*);/define( 'DB_PASSWORD', '$MARIADB_USER_PASSWORD' );/g" /app/wp-config.php
sed -i "s/define\s*(\s*'DB_HOST'\s*,.*);/define( 'DB_HOST', '$MARIADB_HOST' );/g" /app/wp-config.php

echo 'Done'
