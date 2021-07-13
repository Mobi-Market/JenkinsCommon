#!/bin/bash

#set -e

if [ -z "$WORKSPACE" ]; then
  WORKSPACE=$(pwd)
fi

rm -rf Artifacts
rm -f .php_cs.cache
rm -f .prettierignore
rm -f .prettierrc
rm -f rsync.txt
rm -f yarn-error.txt
rm -rf scripts
rm -f .phpunit.result.cache
rm -f phpstan.neon
rm -f changefile.txt
rm -f changelog.txt
rm -f Jenkinsfile
rm -f gulpfile.js
rm -f package.json
rm -f package-lock.json
rm -f composer.json
rm -f composer.lock
rm -f phpunit.xml
rm -f server.php
rm -rf .git
rm -f swagger.json
rm -f swagger.yaml
rm -f .gitattributes
rm -f readme.md
rm -f yarn.lock
rm -f .php_cs
rm -f .editorconfig
rm -f .phpunit.result.cache
rm -f phpstan.neon
rm -f worker.txt
rm -f yarn-error.txt
rm -f rsync.txt
rm -f *.zip
rm -f .git
rm -rf .vscode
rm -rf storage
rm -rf resources/assets
rm -rf node_modules
rm -rf Jenkins
rm -rf tests
rm -f .env.live
rm -f .env.develop
rm -f .env.local
rm -f .env
rm -f debugArtisan