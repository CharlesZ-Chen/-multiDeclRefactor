#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)

##### build hacked checkstyle
if [ ! -d $SCRIPT_DIR/checkstyle ] ; then
    (cd $SCRIPT_DIR && git clone --depth 1 --branch multiDeclJson https://github.com/CharlesZ-Chen/checkstyle.git)
    (cd $SCRIPT_DIR/checkstyle && mvn clean package -Passembly)
fi
(cd $SCRIPT_DIR/checkstyle && git pull)
