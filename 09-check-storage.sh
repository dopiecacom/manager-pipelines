#!/bin/bash



APP_DIR="/app"
STORAGE_DIR="$APP_DIR/wp-content/uploads"


function check_storage_exist() {


if [ -d "$STORAGE_DIR" ];then
    if [ -z "$(ls -A $STORAGE_DIR)" ]; then
      echo "$STORAGE_DIR Directory is empty. Downloading data from backup";
      /helpers/storage-backup-restore.sh
    else
      echo "$STORAGE_DIR contain files. Skipping";
    fi
else
  echo "[ $STORAGE_DIR ] does not exist. Downloading data from backup";
  /helpers/storage-backup-restore.sh
fi

}

check_storage_exist

