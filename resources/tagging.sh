#!/bin/bash
echo pushing tag...

if [ "$BRANCH_NAME" == "master" ]; then
	GIT_TAG="v.$BUILD_NUMBER" 
	GIT_MSG="release $BUILD_NUMBER"

	GIT_REMOTE="$(git ls-remote --get-url)"
	STRIPPED_URL="${GIT_URL/https:\/\/}"
	REMOTE="https://$GIT_USER:$GIT_PASSWORD@$STRIPPED_URL"
	echo git remote = $GIT_REMOTE
	echo git tag -a $GIT_TAG -m $GIT_MSG
	git tag -a "$GIT_TAG" -m "$GIT_MSG"
	echo git push $REMOTE --tags
	git push $REMOTE HEAD:$BRANCH_NAME --tags

	echo pushing tag...Done
fi