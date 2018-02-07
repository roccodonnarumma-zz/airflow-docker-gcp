#!/bin/bash

: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Local}Executor}"
export AIRFLOW__CORE__EXECUTOR

mkdir -p ${AIRFLOW_HOME}/logs

case "$1" in
  webserver)
    echo "init db"
    airflow initdb
    echo "starting webserver" 
    if [ "${AIRFLOW__CORE__EXECUTOR}" = "LocalExecutor" ];
    then
      echo "starting scheduler"
      nohup airflow scheduler > ${AIRFLOW_HOME}/logs/scheduler.logs &
    fi
    nohup airflow webserver > ${AIRFLOW_HOME}/logs/webserver.logs
    ;;
  scheduler)
    sleep 10
    nohup airflow scheduler > ${AIRFLOW_HOME}/logs/scheduler.logs
    ;;
  worker)
    sleep 10
    nohup airflow worker > ${AIRFLOW_HOME}/logs/worker.logs
    ;;
  flower)
    sleep 10
    nohup airflow flower > ${AIRFLOW_HOME}/logs/flower.logs
    ;;
  *)
    exec "$@"
    ;;
esac

#nohup airflow webserver $* >> ${AIRFLOW_HOME}/logs/webserver.logs &
#nohup airflow scheduler >> ${AIRFLOW_HOME}/logs/scheduler.logs &
