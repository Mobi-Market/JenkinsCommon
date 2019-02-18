echo branch is $BRANCH_NAME

if ["$BRANCH_NAME" = "master"]
then
	echo pushing tag...
	git tag -a v.$BUILD_NUMBER -m "release $BUILD_NUMBER"
	git push origin --tags
	echo pushing tag...Done
fi

if ["$BRANCH_NAME" = "integration"]
then
	echo pushing tag...
	git tag -a rc.$BUILD_NUMBER -m "release candidate $BUILD_NUMBER"
	git push origin --tags
	echo pushing tag...Done
else
	echo Not Master or Integration branch, skipping tagging.
fi
