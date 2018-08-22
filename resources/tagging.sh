if ["$BRANCH_NAME" == "master"]
then
	echo pushing tag...
	git tag -a $BUILD_NUMBER -m "release $BUILD_NUMBER"
	git push origin --tags
	echo pushing tag...Done
else
	echo Not Master branch, skipping tagging.
fi