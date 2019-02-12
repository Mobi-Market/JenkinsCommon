#!/bin/bash

#set -e

if [ -z "$WORKSPACE" ]; then
  WORKSPACE=$(pwd)
fi

if [ -f "$WORKSPACE/archive.config" ]; then
  . "$WORKSPACE/archive.config"
fi

ARTIFACT_ROOT="$WORKSPACE/Artifacts"
ARTIFACT_DOCS_ROOT="$ARTIFACT_ROOT/Documentation"

if [ -d "$ARTIFACT_ROOT" ]; then
  rm -rf $WORKSPACE/Artifacts
fi

mkdir "$ARTIFACT_ROOT"

if [ ! -d "$ARTIFACT_DOCS_ROOT" ]; then
    mkdir "$ARTIFACT_DOCS_ROOT"
fi

if [ -z "$CHANGELOG_FILE" ]; then
    CHANGELOG_FILE="$WORKSPACE/changelog.txt"
fi

if [ -z "$CHANGEFILE_FILE" ]; then
    CHANGEFILE_FILE="$WORKSPACE/changefile.txt"
fi

if [ -f "$CHANGELOG_FILE" ]; then
  cp "$CHANGELOG_FILE" "$ARTIFACT_DOCS_ROOT/changelog.txt"
fi

if [ -f "$CHANGEFILE_FILE" ]; then
  cp "$CHANGEFILE_FILE" "$ARTIFACT_DOCS_ROOT/changefile.txt"
fi

#copy everything we need bar excluded dirs

EXCLUDE_FILES="--exclude changefile.txt --exclude changelog.txt --exclude Jenkinsfile --exclude $CHANGEFILE_FILE --exclude gulpfile.js --exclude package.json --exclude package-lock.json --exclude composer.json --exclude composer.lock --exclude phpunit.xml --exclude server.php --exclude .git* --exclude swagger.json --exclude swagger.yaml --exclude .gitattributes --exclude readme.md --exclude yarn.lock --exclude .php_cs"
EXCLUDE_DIRECTORIES="--exclude .git/ --exclude .vscode/ --exclude storage/logs --exclude storage/framework/cache/ --exclude storage/framework/sessions/ --exclude storage/framework/views/ --exclude resources/assets/ --exclude Artifacts/ --exclude reports/ --exclude node_modules/ --exclude Jenkins/ --exclude tests/"
FULL_EXCLUDE="$EXCLUDE_FILES $EXCLUDE_DIRECTORIES"
echo rsync -avz $FULL_EXCLUDE $WORKSPACE/ $ARTIFACT_ROOT --progress
rsync -avz $FULL_EXCLUDE $WORKSPACE/ $ARTIFACT_ROOT --progress > $ARTIFACT_ROOT/rsync.log

#rsync wont keep empty folders.. so recreate these..
mkdir $ARTIFACT_ROOT/storage/framework/cache
mkdir $ARTIFACT_ROOT/storage/framework/sessions
mkdir $ARTIFACT_ROOT/storage/framework/views

rm $ARTIFACT_ROOT/.env.live
rm $ARTIFACT_ROOT/.env.develop
rm $ARTIFACT_ROOT/.env.local


if ["$BRANCH" == "master"]
then
	echo pushing tag...
	git tag -a $BUILD_NUMBER -m "release $BUILD_NUMBER"
	git push origin --tags
	echo pushing tag...Done
fi