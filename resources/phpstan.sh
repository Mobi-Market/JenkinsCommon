echo "Running PHP STAN..."
if [ -z "$WORKSPACE" ]; then 
  WORKSPACE=$PWD
  echo "WORKSPACE=$WORKSPACE";
fi

REPORT_ROOT="$WORKSPACE/Reports"

if [ ! -d "$REPORT_ROOT" ]; then
    mkdir "$REPORT_ROOT"
fi

PHPSTAN_REPORT_FILE=$REPORT_ROOT/phpstan.checkstyle.xml

phpstan analyse --autoload-file=vendor/autoload.php --no-ansi --no-progress --errorFormat=checkstyle app routes database config > $PHPSTAN_REPORT_FILE

echo "Running PHP STAN...Done"
    