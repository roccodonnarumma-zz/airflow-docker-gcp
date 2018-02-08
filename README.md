# airflow-docker-gcp

This branch runs Airflow in **CeleryExecutor** mode. Please refer to other branches for more configurations.

This repository contains a **Dockerfile** of [apache-airflow](https://github.com/apache/incubator-airflow) 1.8.0 for [Google Cloud Platform](https://www.cloud.google.com) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

## Info

* Based on Python (2.7.14) Stretch Image [python:2.7.14-stretch](https://hub.docker.com/_/python/)
* Uses [MySQL](https://hub.docker.com/_/mysql/) as backend
* Uses [RabbitMQ](https://hub.docker.com/_/rabbitmq/) as queue

## Installation

* Install [Docker](https://www.docker.com/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)

Pull the image from the Docker repository.

        docker pull roccodonnarumma/airflow-gcp

## Build

In case you need to customize it, edit the Dockerfile and then build it.

        docker build --rm -t roccodonnarumma/airflow-gcp .

## Usage

Bring the cluster up:

        docker-compose up -d


## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)
- Flower: [localhost:5555](http://localhost:5555/)


## Scale the number of workers

Easy scaling using docker-compose:

        docker-compose scale worker=5

This can be used to scale to a multi node setup using kubernetes.
