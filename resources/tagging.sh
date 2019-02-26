#!/bin/bash
echo pushing tag...

if [ "$BRANCH_NAME" == "master" ]; then
	GIT_TAG="v.$BUILD_NUMBER" 
	GIT_MSG="release $BUILD_NUMBER"
fi

if [ "$BRANCH_NAME" == "integration" ]; then
	GIT_TAG="rc.$BUILD_NUMBER" 
	GIT_MSG="release candidate $BUILD_NUMBER"
fi

echo git tag -a $GIT_TAG -m $GIT_MSG
git tag -a "$GIT_TAG" -m "$GIT_MSG"
echo git push origin --tags
git push origin --tags

echo pushing tag...Done