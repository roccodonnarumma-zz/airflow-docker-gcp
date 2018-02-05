FROM python:2.7.14-stretch
MAINTAINER rdonnarumma

ARG AIRFLOW_VERSION=1.8.0
ARG AIRFLOW_HOME=/usr/local/airflow

ENV AIRFLOW_HOME=${AIRFLOW_HOME}

RUN apt-get update -y \
    && apt-get upgrade -y

RUN apt-get install -y python-dev \
    python-pip \
    build-essential \
    git \
    curl

RUN pip install setuptools \
    && pip install airflow[celery,gcp_api,mysql,rabbitmq] \
    && pip install MySQL-python

ADD airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
RUN chmod 777 ${AIRFLOW_HOME}/airflow.cfg

ADD dags/ ${AIRFLOW_HOME}/dags
RUN chmod 777 -R ${AIRFLOW_HOME}/dags

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod 777 /root/entrypoint.sh

EXPOSE 8080 5555 8793

ENTRYPOINT ["/root/entrypoint.sh"]
