#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

CHECK_STYLE_DIR=$SCRIPT_DIR/checkstyle

CHECK_STYLE_ALL_JAR=$CHECK_STYLE_DIR/target/checkstyle-7.4-SNAPSHOT-all.jar

java -jar $CHECK_STYLE_ALL_JAR -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@" |  python $SCRIPT_DIR/multiDeclRefactor.py

##develop version call: using eclipse output of checkstyle, running refactor frontend
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@" | python $SCRIPT_DIR/multiDeclRefactor.py

## develop version call: using eclipse output of checkstyle, print AST tree
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -t "$@"
