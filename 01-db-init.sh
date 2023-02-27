#!/bin/bash


#export PROTOCOL=$PROTOCOL
#export DOMAIN_NAME_URL=$DOMAIN_NAME_URL
#export MARIADB_DATABASE_NAME=$MARIADB_DATABASE
export MARIADB_USER_PASSWORD=$(cat $MARIADB_USER_PASSWORD_FILE)

MARIADB_ROOT_PASSWORD=$(cat $MARIADB_ROOT_PASSWORD_FILE)

aws --profile default configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws --profile default configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws --profile default configure set region "$REGION"





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




#tail -f /dev/null

##!/bin/bash
#
#S3_ENDPOINT_URL=https://s3.gra.io.cloud.ovh.net/
#S3_DB_BUCKUP_BUCKET_NAME="test-verdilab"
#
#aws --profile default configure set aws_access_key_id "dde724c5b0fe4f899820cd555d57025b"
#aws --profile default configure set aws_secret_access_key "b26b111158a0462f9d473f4723e6b048"
#aws --profile default configure set region "gra"
#
#lastest_db_backup_file_name=$(aws s3api list-objects-v2 --bucket "$S3_DB_BUCKUP_BUCKET_NAME" --endpoint-url $S3_ENDPOINT_URL  --query "sort_by(Contents[?contains(Key, 'database-backup-archive') && ends_with(Key, '.gz')], &LastModified)[-1].Key" --output=text)
#
#
#FILE=/backup/backup.sql
#if [[ -f "$FILE" ]]; then
#  mariadb -uroot -p"$(cat /run/secrets/mysql_root_password)" "$APP_DB_NAME" < /backup/"$FILE"
#else
#    echo "Backup file not detected, trying download backup from remote server..."
#    aws s3 cp s3://"$S3_DB_BUCKUP_BUCKET_NAME"/"$lastest_db_backup_file_name" /backup/"$lastest_db_backup_file_name" --endpoint-url $S3_ENDPOINT_URL  &&
#    echo "Backup downloaded successfully! Archive name:$lastest_db_backup_file_name" &&
#    rm -rf /backup/unpack &&
#    mkdir -p /backup/unpack &&
#    echo "Unpacking ..." &&
#    gunzip -c /backup/"$lastest_db_backup_file_name" >/backup/unpack/backup.sql &&
#    echo "Restoring database..." &&
#    mariadb -uroot -p"$(cat /run/secrets/mysql_root_password)" "$APP_DB_NAME" < /backup/unpack/backup.sql &&
#    echo "Database restored successfully! [$lastest_db_backup_file_name]"
#    rm -rf /backup/unpack
#    rm -rf /backup/$lastest_db_backup_file_name
#fi
#

