#!/bin/bash

echo "Running PHP CS..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

REPORT_ROOT="$WORKSPACE/reports"

if [ ! -d "$REPORT_ROOT" ]; then
    mkdir "$REPORT_ROOT"
fi

composer format

git add .
git commit -m "Build Server Commiting code fixer changes"
git push origin 
echo "Running PHP CS...Done"