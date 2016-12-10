#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/.. && pwd)
java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -c multiDeclChecks.xml -f json "$@"
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -t "$@"
