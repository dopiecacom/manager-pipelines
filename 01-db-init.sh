#!/bin/bash


export MARIADB_USER_PASSWORD=$(cat $MARIADB_USER_PASSWORD_FILE)

MARIADB_ROOT_PASSWORD=$(cat $MARIADB_ROOT_PASSWORD_FILE)



envsubst < "/sql-templates/create-users.sql.template"
envsubst < "/sql-templates/create-database.sql.template"


mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "/sql-templates/create-users.sql.template")

if ! mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" -e "use $MARIADB_DATABASE" > /dev/null 2>&1; then
  echo "Nie znalazlem bazy. Przywracam z backupu"
  mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "/sql-templates/create-database.sql.template")
  /helpers/db-backup-restore.sh
fi

if mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" mysql -e "desc $MARIADB_DATABASE.wp_options" > /dev/null 2>&1 ; then
  echo "Ustawiam URL w tabeli wp_options."
  mariadb -h db -uroot -p"$MARIADB_ROOT_PASSWORD" < <(envsubst < "/sql-templates/change-domain-in-db.sql.template")
else
 echo "Nie znalazlem tabeli wp_options. Pomijam ustawianie domeny."
fi

