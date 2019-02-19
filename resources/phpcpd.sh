#!/bin/bash

echo "Running PHP CPD..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

REPORT_ROOT="$WORKSPACE/reports"

if [ ! -d "$REPORT_ROOT" ]; then
    mkdir "$REPORT_ROOT"
fi

PHPCPD_REPORT_FILE=$REPORT_ROOT/phpcpd.pmd.xml

phpcpd --log-pmd=$PHPCPD_REPORT_FILE app routes database config

echo "Running PHP CPD...Done"