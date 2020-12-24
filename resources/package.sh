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



echo detected $GIT_BRANCH branch
if [ "$GIT_BRANCH" == "master" ]; then
  $PHP_EXEC /usr/bin/composer install --no-dev --no-interaction
else
  $PHP_EXEC /usr/bin/composer install --no-interaction
fi

php artisan cache:clear --env=prod
php artisan clear-compiled
# php artisan optimize

if [ "$SYSTEM_NAME" == "MobiMarket" ]; then
  yarn run develop
else 
  yarn run prod
fi

echo "Running Package...Done"