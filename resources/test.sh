#!/bin/bash

# set -e

echo "Setting Up workspace..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi
echo "Setting Up workspace...Done"

echo "Checking for test Config..."
if [ -f "$WORKSPACE/test.config" ]; then
  echo "Loading config variables from $WORKSPACE/test.config"
  . "$WORKSPACE/test.config"
fi
echo "Checking for test Config...Done"

echo "Setting up log file..."
if [ -z "${TEST_LOG_FILE}" ]; then
  TEST_LOG_FILE="$WORKSPACE/test.log";
fi
echo "Setting up log file...Done"

echo "reoving old log file..."
if [ -f $TEST_LOG_FILE ]; then
    rm -f $TEST_LOG_FILE
fi
echo "reoving old log file...Done"

echo "Setting up Tests uite..."
if [ -z "$TEST_SUITE" ]; then
    TEST_SUITE="Jenkins"
fi
echo "Setting up Test suite...Done"

echo "Setting up PHP Unit..."
if [ -f "$WORKSPACE/vendor/phpunit/phpunit/phpunit" ]; then
	echo "Using version of phpunit from vendor directory: $WORKSPACE/vendor/phpunit/phpunit/phpunit"
	PHPUNIT_PHAR="$WORKSPACE/vendor/phpunit/phpunit/phpunit"
fi
echo "Setting up PHP Unit...Done"


echo "Setting up PHPUNIT Phar..."
if [ -z "$PHPUNIT_PHAR" ]; then
  echo "Global PHP unit being used:";
  PHPUNIT_PHAR=/usr/local/bin/phpunit
fi
echo "Setting up PHPUNIT Phar...Done"

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

echo "Setting up unit tests report..."
if [ -z "$UNITTESTDIR" ]; then
    UNITTESTDIR="$REPORTDIR/unit-tests"
fi
echo "Setting up unit tests report...Done"

echo "Setting up junit..."
if [ -z "$JUNIT_LOG" ]; then
    JUNIT_LOG="$UNITTESTDIR/$TEST_SUITE-phpunit-junit.xml"
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
    PHPUNIT_EXTRA_OPTS="--coverage-html $COVERRAGEDIR --coverage-clover $COVERRAGEDIR/$TEST_SUITE-coverage.xml"
fi
echo "Creating Directories etc...Done"

# if [ "$STOP_ON_FAILURE" = "true" ]; then
#     echo Will stop on any failures/warnings
#     PHPUNIT_EXTRA_OPTS="$PHPUNIT_EXTRA_OPTS --stop-on-failure"
# fi

# echo Using Pretty Printer
# PHPUNIT_EXTRA_OPTS="$PHPUNIT_EXTRA_OPTS --printer "DiabloMedia\PHPUnit\Printer\PrettyPrinter""

echo "Setting up output file..."
PHPUNIT_EXTRA_OPTS="$PHPUNIT_EXTRA_OPTS --testdox-text unitTestOutput.txt"
echo "Setting up output file...Done"


echo "phpunit Location: $PHPUNIT_PHAR"
$PHPUNIT_PHAR --version

echo "executing $TEST_SUITE test suite"
echo "executing: $PHPUNIT_PHAR -c $WORKSPACE/phpunit.xml --testsuite $TEST_SUITE --log-junit $JUNIT_LOG $PHPUNIT_EXTRA_OPTS"
php $PHPUNIT_PHAR -c $WORKSPACE/phpunit.xml --testsuite $TEST_SUITE --log-junit $JUNIT_LOG $PHPUNIT_EXTRA_OPTS

echo "Running tests...Complete"