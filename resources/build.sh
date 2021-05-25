#!/bin/bash
set -e
echo .
echo "Using PHP verion:"
$PHP_EXEC -v
echo .
echo "Running build..."
echo Name: $SYSTEM_NAME
if [ -z "$WORKSPACE" ]; then
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/build.config" ]; then
  echo "Loading config variables from $WORKSPACE/build.config"
  . "$WORKSPACE/build.config"
fi

if [ -d "$WORKSPACE/storage" ]; then
  echo "removing $WORKSPACE/storage"
  rm -rf "$WORKSPACE/storage"
fi

if [ ! -d "$WORKSPACE/storage" ]; then
  echo "creating $WORKSPACE/storage"
  mkdir -p "$WORKSPACE/storage/app"
  mkdir -p "$WORKSPACE/storage/framework"
  mkdir -p "$WORKSPACE/storage/framework/cache"
  mkdir -p "$WORKSPACE/storage/framework/sessions"
  mkdir -p "$WORKSPACE/storage/framework/testing"
  mkdir -p "$WORKSPACE/storage/framework/views"
  mkdir -p "$WORKSPACE/storage/logs"
fi

# if [ -d "$WORKSPACE/node_modules" ]; then
#   echo "removing $WORKSPACE/node_modules"
#   rm -rf "$WORKSPACE/node_modules"
# fi

# if [ -f "$WORKSPACE/package-lock.json" ]; then
#   echo "removing $WORKSPACE/package-lock.json"
#   rm -f "$WORKSPACE/package-lock.json"
# fi

# GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
echo detected $GIT_BRANCH branch
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
$PHP_EXEC /usr/bin/composer install --no-scripts

phive install --trust-gpg-keys 4AA394086372C20A,CF1A108D0E7AE720,4AA394086372C20A,6DA3ACC4991FFAE5,E82B2FB314E9906E

if [ -s "$WORKSPACE/yarn.lock" ]; then
  JSPM_BIN=yarn
  $JSPM_BIN install
else
  JSPM_BIN=npm
  $JSPM_BIN ci
fi

if [ "$SYSTEM_NAME" == "MobiMarket" ]; then
  $JSPM_BIN run develop
else
  $JSPM_BIN run prod
fi

$PHP_EXEC artisan key:generate --force

echo "Running build...Complete"
