echo "Running PHP Doc..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

DOCS_ROOT="$WORKSPACE/Documentation"

if [ ! -d "$DOCS_ROOT" ]; then
    mkdir "$DOCS_ROOT"
fi
DOC_API="$DOCS_ROOT/api"
if [ ! -d "$DOC_API" ]; then
    mkdir "$DOC_API"
fi

phpdoc -d app -d database -d routes -d config -t $DOC_API

echo "Running PHP Doc...Done"