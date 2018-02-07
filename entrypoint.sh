#!/bin/bash

: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Local}Executor}"
export AIRFLOW__CORE__EXECUTOR

mkdir -p ${AIRFLOW_HOME}/logs

nohup /opt/cloud_sql_proxy/cloud_sql_proxy -instances=gcp-rocco:us-central1:airflow-db=tcp:3306 &

case "$1" in
  webserver)
    echo "init db"
    sleep 10
    airflow initdb
    echo "starting webserver" 
    if [ "${AIRFLOW__CORE__EXECUTOR}" = "LocalExecutor" ];
    then
      echo "starting scheduler"
      nohup airflow scheduler > ${AIRFLOW_HOME}/logs/scheduler.logs &
    fi
    airflow run add_gcp_connection add_gcp_connection_python 2018-01-10
    nohup airflow webserver > ${AIRFLOW_HOME}/logs/webserver.logs
    echo "done"
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
