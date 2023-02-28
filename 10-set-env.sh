#!/bin/bash

ENV_PATH=/app/.env

echo 'Configuring .ENV file.' &&

cp /app/.env.example $ENV_PATH &&





#
echo "" >> $ENV_PATH &&
#
sed -i "s/DB_HOST.*=.*//g" $ENV_PATH &&
echo "DB_HOST=\"$MARIADB_HOST\"" >> $ENV_PATH &&

sed -i "s/DB_DATABASE.*=.*//g" $ENV_PATH &&
echo "DB_DATABASE=\"$MARIADB_DATABASE\"" >> $ENV_PATH &&

sed -i "s/DB_USERNAME.*=.*//g" $ENV_PATH &&
echo "DB_USERNAME=\"$MARIADB_USER\"" >> $ENV_PATH &&

sed -i "s/DB_PASSWORD.*=.*//g" $ENV_PATH &&
echo "DB_PASSWORD=\"$(cat "$MARIADB_USER_PASSWORD_FILE" | head -n 1)\"" >> $ENV_PATH;


