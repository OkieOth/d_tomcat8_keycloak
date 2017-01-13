#!/bin/bash

for f in /opt/extraConf/*; do
    case "$f" in
    *.xml)    echo "$0: copying $f"; cp "$f" /opt/tomcat/conf/Catalina/localhost ;;
    *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

export JAVA_OPTS="-Dfile.encoding=utf-8"

if [ "$1" = "debug" ] ; then
    JPDA_TRANSPORT="dt_socket"
    JPDA_ADDRESS="8000"
    JPDA_SUSPEND="n"
    JPDA_OPTS="-agentlib:jdwp=transport=$JPDA_TRANSPORT,address=$JPDA_ADDRESS,server=y,suspend=$JPDA_SUSPEND"
    export CATALINA_OPTS="$JPDA_OPTS $CATALINA_OPTS"
fi


export CATALINA_BASE=/opt/tomcat

/usr/local/tomcat/bin/catalina.sh run

