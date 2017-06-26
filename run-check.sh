#!/bin/bash
ROOT_DIR=$(cd $(dirname "$0")/.. && pwd)

MULTI_DECL_REFACTOR_DIR=$ROOT_DIR/multiDeclRefactor

# Uncomment below line and configure your dev check style dir
# DEV_CHECK_STYLE_DIR=$ROOT_DIR/checkstyle

CHECK_STYLE_DIR=$MULTI_DECL_REFACTOR_DIR/checkstyle

# Uncomment below line if using DEV_CHECK_STYLE
# CHECK_STYLE_DIR=$DEV_CHECK_STYLE_DIR

CHECK_STYLE_ALL_JAR=$CHECK_STYLE_DIR/target/checkstyle-7.4-SNAPSHOT-all.jar

java -jar $CHECK_STYLE_ALL_JAR -c $MULTI_DECL_REFACTOR_DIR/multiDeclChecks.xml -f json "$@"

# Uncomment below line if using eclipse output classes of checkstyle
# TODO: copy the mvn cmd of "copy dependencies here"
# java -cp $CHECK_STYLE_DIR/target/classes:$(ls $CHECK_STYLE_DIR/target/dependency/*.jar | tr '\n' : | rev | cut -c 2- | rev) com.puppycrawl.tools.checkstyle.Main -c $MULTI_DECL_REFACTOR_DIR/multiDeclChecks.xml -f json "$@"

# mvn clean install -DskipTests -Dcheckstyle.ant.skip -Dcobertura.skip
