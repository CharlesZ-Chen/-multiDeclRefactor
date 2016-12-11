#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
ROOT_DIR=$(cd $SCRIPT_DIR/.. && pwd)

CHECK_STYLE_ALL_JAR=$ROOT_DIR/checkstyle/target/checkstyle-7.4-SNAPSHOT-all.jar

java -jar $CHECK_STYLE_ALL_JAR -c multiDeclChecks.xml -f json "$@"


# mvn clean install -DskipTests -Dcheckstyle.ant.skip -Dcobertura.skip
