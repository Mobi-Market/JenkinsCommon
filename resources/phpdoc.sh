echo "Running PHP CS..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

DOCS_ROOT="$WORKSPACE/Docs"

if [ ! -d "$DOCS_ROOT" ]; then
    mkdir "$DOCS_ROOT"
fi

phpdoc -d app -d database -d routes -d config -t $DOCS_ROOT

echo "Running PHP CS...Done"