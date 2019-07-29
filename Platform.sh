#!/bin/bash
#********************************************************
#
# Name: lsf-stop-spark.sh 
#
# (c) Copyright International Business Machines Corp 2016.
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# This script is used to stop the spark daemon.
#********************************************************
#set environments, modify it to yours
SPARK_HOME=/usr/local/spark
if [ -z "$SPARK_HOME" ]; then
    echo "SPARK_HOME variable is not set in lsf-stop-spark.sh"
    exit 1
fi

. "$SPARK_HOME/sbin/spark-config.sh"
. "$SPARK_HOME/bin/load-spark-env.sh"

if [ ! -d "$SPARK_PID_DIR" ]; then
    echo "can not find the SPARK_PID_DIR"
    exit 1
fi

files=`ls $SPARK_PID_DIR`
if [ -z "$files" ]; then
    echo "SPARK_PID_DIR is empty"
    exit 1
fi

if [ ! -z `echo "$files" | grep "worker"` ]; then
    "$SPARK_HOME/sbin"/stop-slave.sh
fi

if [ ! -z `echo "$files" | grep "master"` ]; then
    "$SPARK_HOME/sbin"/stop-master.sh
fi

sleep 5

if [ -z `ls $SPARK_PID_DIR` ]; then
    JOB_ID=${LSB_JOBID}_${LSB_JOBINDEX}
    rm -rf $SPARK_PID_DIR/../$JOB_ID
fi
