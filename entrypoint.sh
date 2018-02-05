#!/bin/bash

mkdir -p ${AIRFLOW_HOME}
cd ${AIRFLOW_HOME}

mkdir -p ${AIRFLOW_HOME}/logs

airflow initdb

nohup airflow webserver $* >> ${AIRFLOW_HOME}/logs/webserver.logs &
nohup airflow scheduler >> ${AIRFLOW_HOME}/logs/scheduler.logs
