#!/bin/bash
cd /app/wp-content/themes/verdilab
npm install &&
npm run prod
chmod -R 777 /app/wp-content/languages
