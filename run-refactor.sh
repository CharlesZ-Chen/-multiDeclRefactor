#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/.. && pwd)
java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@" | python $SCRIPT_DIR/multiDeclRefactor.py
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -t "$@"
