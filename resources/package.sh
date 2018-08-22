#!/bin/bash

set -e

echo "Running Package..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/package.config" ]; then
  echo "Loading config variables from $WORKSPACE/package.config"
  . "$WORKSPACE/package.config"
fi

composer install --no-dev

php artisan cache:clear --env=prod
php artisan clear-compiled
php artisan optimize

echo "Running Package...Done"