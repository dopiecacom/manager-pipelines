#!/bin/bash

APP_DIR="/app"
PLUGINS_DIR="$APP_DIR/wp-content/plugins"


function prepare_wp_plugins() {
  find $PLUGINS_DIR/* -name "*" -not -name "*.zip" -delete &&
  cd $PLUGINS_DIR &&
  for z in *.zip; do unzip -q "$z"; done
}

cd $APP_DIR || exit;
prepare_wp_plugins

