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

composer php-cpd-build

echo "Running PHP CPD...Done"