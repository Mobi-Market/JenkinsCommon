#!/bin/bash

set -e

echo "Running documentation..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

git describe --long --dirty --always > git.tmp

GITDESCRIBE=$(cat git.tmp)

echo GITDESCRIBE=$GITDESCRIBE > "$WORKSPACE/git.properties"

GIT_BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

echo GIT_BRANCH=$GIT_BRANCH >> "$WORKSPACE/git.properties"
echo Building as $GIT_BRANCH:$GITDESCRIBE

rm git.tmp
