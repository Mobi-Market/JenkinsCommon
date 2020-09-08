#!/bin/bash
set -e
echo .
echo "Using PHP verion:"
$PHP_EXEC -v
echo .
echo "Running build..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/build.config" ]; then
  echo "Loading config variables from $WORKSPACE/build.config"
  . "$WORKSPACE/build.config"
fi

# if [ -d "$WORKSPACE/vendor" ]; then
#   echo "removing $WORKSPACE/vendor"
#   rm -rf "$WORKSPACE/vendor"
# fi

# if [ -d "$WORKSPACE/node_modules" ]; then
#   echo "removing $WORKSPACE/node_modules"
#   rm -rf "$WORKSPACE/node_modules"
# fi

# if [ -f "$WORKSPACE/package-lock.json" ]; then
#   echo "removing $WORKSPACE/package-lock.json"
#   rm -f "$WORKSPACE/package-lock.json"
# fi

GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

if [ "$GIT_BRANCH" == "master" ]; then
  echo master branch detected using $WORKSPACE/.env.live
  cp $WORKSPACE/.env.live $WORKSPACE/.env
elif [ "$GIT_BRANCH" == "integration" ]; then
  echo develop branch detected using $WORKSPACE/.env.develop
  cp $WORKSPACE/.env.develop $WORKSPACE/.env
else
  echo unknown branch detected using $WORKSPACE/.env.local
  cp $WORKSPACE/.env.local $WORKSPACE/.env
fi

#ensure latest composer
# composer self-update
# no need for dev deps
$PHP_EXEC /usr/local/bin/composer install --no-scripts

phive install

yarn install

yarn run prod

$PHP_EXEC artisan key:generate

echo "Running build...Complete"