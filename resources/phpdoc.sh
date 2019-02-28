#!/bin/bash

echo "Running PHP Doc..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

DOCS_ROOT="$WORKSPACE/documentation"

if [ ! -d "$DOCS_ROOT" ]; then
    mkdir "$DOCS_ROOT"
fi

composer php-doc

echo "Running PHP Doc...Done"