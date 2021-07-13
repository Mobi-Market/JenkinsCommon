#!/bin/bash

# set -e

echo "Setting Up workspace..."
if [ -z "$WORKSPACE" ]; then
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi
echo "Setting Up workspace...Done"

echo "Setting up Reports..."
if [ -z "$REPORTDIR" ]; then
    REPORTDIR="$WORKSPACE/reports"
fi
echo "Setting up Reports...Done"

echo "Setting up Coverage..."
if [ -z "$COVERRAGEDIR" ]; then
    COVERRAGEDIR="$REPORTDIR/coverage"
fi
echo "Setting up Coverage...Done"

echo "Setting up junit..."
if [ -z "$JUNIT_LOG" ]; then
    JUNIT_LOG="$REPORTDIR/$COMPOSER_CMD-phpunit-junit.xml"
fi
echo "Setting up junit...Done"

echo "Creating Directories etc..."
if [ "$CREATE_COVERAGE_REPORT" = "true" ]; then
    echo cleaning up reports "$REPORTDIR"..

    if [ -d "$REPORTDIR" ]; then
        echo removing old reports directory...
        rm -rf "$REPORTDIR"
    fi

    echo creating $REPORTDIR...
    echo creating $COVERRAGEDIR...
    echo creating $UNITTESTDIR...

    mkdir $REPORTDIR
    mkdir $COVERRAGEDIR
    mkdir $UNITTESTDIR


    echo cleaning up reports "$REPORTDIR"..Done
fi
echo "Creating Directories etc...Done"


echo "phpunit Location: RUNNING USING COMPOSER COMMAND"

composer $COMPOSER_CMD

echo "Running tests...Complete"