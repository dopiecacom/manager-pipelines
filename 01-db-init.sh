#!/bin/bash

SQL_TEMPLATES_DIR_PATH=/docker-entrypoint-init.d/sql-templates

export MARIADB_USER_PASSWORD=$(cat $MARIADB_USER_PASSWORD_FILE)

MARIADB_ROOT_PASSWORD=$(cat $MARIADB_ROOT_PASSWORD_FILE)



envsubst < "$SQL_TEMPLATES_DIR_PATH/create-users.sql.template"
envsubst < "$SQL_TEMPLATES_DIR_PATH/create-database.sql.template"


mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "$SQL_TEMPLATES_DIR_PATH/create-users.sql.template")

if ! mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" -e "use $MARIADB_DATABASE" > /dev/null 2>&1; then
  echo "Nie znalazlem bazy. Przywracam z backupu"
  mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "$SQL_TEMPLATES_DIR_PATH/create-database.sql.template")
  /helpers/db-backup-restore.sh
fi

if mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" mysql -e "desc $MARIADB_DATABASE.wp_options" > /dev/null 2>&1 ; then
  echo "Ustawiam URL w tabeli wp_options."
  mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "$SQL_TEMPLATES_DIR_PATH/change-domain-in-db.sql.template")
else
 echo "Nie znalazlem tabeli wp_options. Pomijam ustawianie domeny."
fi

