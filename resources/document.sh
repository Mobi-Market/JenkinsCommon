#!/bin/bash

set -e

echo "Running documentation..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/document.config" ]; then
  echo "Loading config variables from $WORKSPACE/document.config"
  . "$WORKSPACE/document.config"
fi

if [ ! -n "$CHANGELOG_FILE" ]; then
    CHANGELOG_FILE="$WORKSPACE/changelog.txt"
fi
echo changelog file: $CHANGELOG_FILE

if [ ! -n "$CHANGEFILE_FILE" ]; then
    CHANGEFILE_FILE="$WORKSPACE/changefile.txt"
fi
echo changefile file: $CHANGEFILE_FILE
#ensure path include git bash
PATH=$PATH:/bin

echo creating files...
touch $CHANGELOG_FILE
touch $CHANGEFILE_FILE
echo creating files...done

#ensure changelog file is not dirty
# git cat-file -e HEAD~1:$CHANGELOG_FILE #> /dev/null 2>&1
# echo after cat-file
# if [ $? -eq 0 ]; then
#   # the file does exist
#   echo update $CHANGELOG_FILE
#   git checkout $CHANGELOG_FILE
# else
# 	echo > $CHANGELOG_FILE
# fi

echo test..

HAVETAGS=false

TAGLIST=`git for-each-ref refs/tags --count=1`

echo taglist: $TAGLIST

if [ "$TAGLIST" != "" ]
then
	while read entry;
	do
		HAVETAGS=true
		echo $entry
	done <<< "$TAGLIST"
fi



echo HaveTags:$HAVETAGS

if [ "$HAVETAGS" = true ] 
then
	TAGCOMMITID=`git rev-list --tags --max-count=1`
	TAGNAME=`git describe --abbrev=0 $TAGCOMMITID`
	echo tag commitid:$TAGCOMMITID name:$TAGNAME
	git log --pretty=tformat:"- %s" --since="$(git show -s --format=%ad $TAGCOMMITID)" > RecentChanges.tmp
	echo >> RecentChanges
	echo "# Tagged as $TAGNAME" >> RecentChanges.tmp
	echo >> RecentChanges
	
	echo creating lits of modified files...
	
	FORKPOINT=`git merge-base --fork-point HEAD`
	FORKDESC=`git log --pretty=oneline -1  $FORKPOINT`
	echo "#changed files since $FORKDESC" > changed_files.tmp
	git diff --name-only $FORKPOINT  >> changed_files.tmp
	echo  >> changed_files.tmp
	echo "#changed files since $TAGNAME" >> changed_files.tmp
	git diff --name-only $TAGNAME >> changed_files.tmp
else
	git log --pretty=tformat:"- %s" > RecentChanges.tmp

	echo "#changed files since dawn of time" > changed_files.tmp
	git ls-tree --full-tree --name-only -r HEAD >> changed_files.tmp
fi

cat RecentChanges.tmp $CHANGELOG_FILE > changelog.tmp

mv changelog.tmp $CHANGELOG_FILE

rm RecentChanges.tmp

rm $CHANGEFILE_FILE
mv changed_files.tmp $CHANGEFILE_FILE

git describe --long --dirty --always > git.tmp


GITDESCRIBE=$(cat git.tmp)

echo GITDESCRIBE=$GITDESCRIBE > "$WORKSPACE/git.properties"

GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

echo GIT_BRANCH=$GIT_BRANCH >> "$WORKSPACE/git.properties"
echo Building as $GIT_BRANCH:$GITDESCRIBE

rm git.tmp
