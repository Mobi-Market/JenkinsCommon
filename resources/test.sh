#!/bin/bash

set -e

echo "Running tests..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

if [ -f "$WORKSPACE/test.config" ]; then
  echo "Loading config variables from $WORKSPACE/test.config"
  . "$WORKSPACE/test.config"
fi

if [ -z "${TEST_LOG_FILE}" ]; then
  TEST_LOG_FILE="$WORKSPACE/test.log";
fi

if [ -f $TEST_LOG_FILE ]; then
    rm -f $TEST_LOG_FILE
fi

if [ -f "$WORKSPACE/vendor/phpunit/phpunit/phpunit" ]; then
	echo "Using version of phpunit from vendor directory: $WORKSPACE/vendor/phpunit/phpunit/phpunit"
	PHPUNIT_PHAR="$WORKSPACE/vendor/phpunit/phpunit/phpunit"
fi


if [ -z "$PHPUNIT_PHAR" ]; then
  echo "Global PHP unit being used:";
  PHPUNIT_PHAR=/usr/local/bin/phpunit
fi

if [ -z "$REPORTDIR" ]; then
    REPORTDIR="$WORKSPACE/reports"
fi

if [ -z "$COVERRAGEDIR" ]; then
    COVERRAGEDIR="$REPORTDIR/coverage"
fi

if [ -z "$UNITTESTDIR" ]; then
    UNITTESTDIR="$REPORTDIR/unit-tests"
fi

if [ -z "$JUNIT_LOG" ]; then
    JUNIT_LOG="$UNITTESTDIR/$TEST_SUITE-phpunit-junit.xml"
fi

if [ -z "$TEST_SUITE" ]; then
    TEST_SUITE="Jenkins"
fi

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

# if [ "$STOP_ON_FAILURE" = "true" ]; then
#     echo Will stop on any failures/warnings
#     PHPUNIT_EXTRA_OPTS="$PHPUNIT_EXTRA_OPTS --stop-on-failure"
# fi

# echo Using Pretty Printer
# PHPUNIT_EXTRA_OPTS="$PHPUNIT_EXTRA_OPTS --printer "DiabloMedia\PHPUnit\Printer\PrettyPrinter""

# echo Piping output to file
PHPUNIT_EXTRA_OPTS=$PHPUNIT_EXTRA_OPTS --testdox-text unitTestOutput.txt



echo phpunit:$PHPUNIT_PHAR
$PHPUNIT_PHAR --version

echo executing $TEST_SUITE test suite
echo executing: $PHPUNIT_PHAR -c $WORKSPACE/phpunit.xml --testsuite $TEST_SUITE --log-junit $JUNIT_LOG $PHPUNIT_EXTRA_OPTS
php  $PHPUNIT_PHAR -c $WORKSPACE/phpunit.xml --testsuite $TEST_SUITE --log-junit $JUNIT_LOG $PHPUNIT_EXTRA_OPTS

echo "Running tests...Complete"