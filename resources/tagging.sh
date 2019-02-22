#!/bin/bash
BRANCH_NAME=integration


echo pushing tag...

if [ "$BRANCH_NAME" == "master" ]; then
	git tag -a v.$BUILD_NUMBER -m "release $BUILD_NUMBER"
fi

if [ "$BRANCH_NAME" == "integration" ]; then
	git tag -a rc.$BUILD_NUMBER -m "release candidate $BUILD_NUMBER"
else

git push origin --tags

echo pushing tag...Done