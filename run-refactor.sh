#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/.. && pwd)

CHECK_STYLE_ALL_JAR=$ROOT_DIR/checkstyle/target/checkstyle-7.4-SNAPSHOT-all.jar

java -jar $CHECK_STYLE_ALL_JAR -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@" |  python $SCRIPT_DIR/multiDeclRefactor.py

##develop version call: using eclipse output of checkstyle, running refactor frontend
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@" | python $SCRIPT_DIR/multiDeclRefactor.py

## develop version call: using eclipse output of checkstyle, print AST tree
# java -cp $ROOT_DIR/checkstyle/target/classes:$(ls $ROOT_DIR/checkstyle/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -t "$@"
