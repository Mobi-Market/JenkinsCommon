#!/bin/bash

#set -e

if [ -z "$WORKSPACE" ]; then
  WORKSPACE=$(pwd)
fi

rm -rf Artifacts
rm .php_cs.cache 
rm .prettierignore 
rm .prettierrc 
rm rsync.txt 
rm yarn-error.txt 
rm -rf scripts
rm .phpunit.result.cache 
rm phpstan.neon 
rm changefile.txt 
rm changelog.txt 
rm Jenkinsfile  
rm gulpfile.js 
rm package.json 
rm package-lock.json 
rm composer.json 
rm composer.lock 
rm phpunit.xml 
rm server.php 
rm -rf .git 
rm swagger.json 
rm swagger.yaml 
rm .gitattributes 
rm readme.md 
rm yarn.lock 
rm .php_cs
rm .editorconfig 
rm .phpunit.result.cache 
rm phpstan.neon 
rm worker.txt 
rm yarn-error.txt 
rm rsync.txt 
rm *.zip
rm .git 
rm -rf .vscode
rm -rf storage
rm -rf resources/assets
rm -rf node_modules 
rm -rf Jenkins
rm -rf tests
rm .env.live
rm .env.develop
rm .env.local
rm .env
rm debugArtisan