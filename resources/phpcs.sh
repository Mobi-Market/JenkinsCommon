#!/bin/bash

echo "Running PHP CS..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

REPORT_ROOT="$WORKSPACE/Reports"

if [ ! -d "$REPORT_ROOT" ]; then
    mkdir "$REPORT_ROOT"
fi

PHPCS_REPORT_FILE=$REPORT_ROOT/phpcs.checkstyle.xml

phpcs --standard PSR2 --report-summary --runtime-set ignore_errors_on_exit 1 --runtime-set ignore_warnings_on_exit 1 --report-checkstyle=$PHPCS_REPORT_FILE app routes database config

echo "Running PHP CS...Done"