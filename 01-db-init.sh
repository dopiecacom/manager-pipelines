#!/bin/bash



export MARIADB_USER_PASSWORD=$(cat $MARIADB_USER_PASSWORD_FILE)
MARIADB_ROOT_PASSWORD=$(cat $MARIADB_ROOT_PASSWORD_FILE)

#envsubst < "/sql-templates/create-users.sql.template"
#envsubst < "/sql-templates/create-database.sql.template"

mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "./sql-templates/create-users.sql.template")




