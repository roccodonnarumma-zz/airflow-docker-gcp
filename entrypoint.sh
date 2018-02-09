#!/bin/bash

: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Local}Executor}"
export AIRFLOW__CORE__EXECUTOR

mkdir -p ${AIRFLOW_HOME}/logs

nohup /opt/cloud_sql_proxy/cloud_sql_proxy -instances=${GCP_PROJECT}:${GCP_REGION}:${GCP_DATABASE_INSTANCE_NAME}=tcp:3306 &

case "$1" in
  webserver)
    mysql -h 127.0.0.1 -u root -e "CREATE DATABASE airflow CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mysql -h 127.0.0.1 -u root -e "grant all on airflow.* TO 'airflow'@'%' IDENTIFIED BY 'airflow';"

    echo "init db"
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
    nohup airflow scheduler > ${AIRFLOW_HOME}/logs/scheduler.logs
    ;;
  worker)
    nohup airflow worker > ${AIRFLOW_HOME}/logs/worker.logs
    ;;
  flower)
    nohup airflow flower > ${AIRFLOW_HOME}/logs/flower.logs
    ;;
  *)
    exec "$@"
    ;;
esac
