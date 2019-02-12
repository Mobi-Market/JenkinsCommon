#!/bin/bash
set -e

echo "Running build..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/build.config" ]; then
  echo "Loading config variables from $WORKSPACE/build.config"
  . "$WORKSPACE/build.config"
fi

echo "setting composer auth..."
echo "BB USR= $BITBUCKET_USR";
composer config -a -g http-basic.bitbucket.org $BITBUCKET_USR $BITBUCKET_PWD
echo "BB PWD= $BITBUCKET_PWD";
echo "setting composer auth...Done"

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
elif [ "$GIT_BRANCH" == "develop" ]; then
  echo develop branch detected using $WORKSPACE/.env.develop
  cp $WORKSPACE/.env.develop $WORKSPACE/.env
else
  echo unknown branch detected using $WORKSPACE/.env.local
  cp $WORKSPACE/.env.local $WORKSPACE/.env
fi

#ensure latest composer
# composer self-update
# no need for dev deps
composer install --no-scripts

yarn install

yarn run prod

php artisan key:generate

echo "Running build...Complete"