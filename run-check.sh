#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
CHECK_STYLE_DIR=$SCRIPT_DIR/checkstyle

CHECK_STYLE_ALL_JAR=$CHECK_STYLE_DIR/target/checkstyle-7.4-SNAPSHOT-all.jar

java -jar $CHECK_STYLE_ALL_JAR -c $SCRIPT_DIR/multiDeclChecks.xml -f json "$@"


# mvn clean install -DskipTests -Dcheckstyle.ant.skip -Dcobertura.skip
