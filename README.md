# airflow-docker-gcp

This branch runs Airflow in **LocalExecutor** mode with **GCP** modules pre-installed. Please refer to other branches for more configurations.

This repository contains a **Dockerfile** of [apache-airflow](https://github.com/apache/incubator-airflow) 1.8.0 for [Google Cloud Platform](https://www.cloud.google.com) published to the public [Docker Hub Registry](https://registry.hub.docker.com/). It contains an example DAG that executes a BigQuery SQL query and export the results into a GCS bucket.

## Info

* Based on Python (2.7.14) Stretch Image [python:2.7.14-stretch](https://hub.docker.com/_/python/)
* Uses [Cloud SQL](https://cloud.google.com/sql/) as backend

## Installation

* Install [Docker](https://www.docker.com/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)

Pull the image from the Docker repository.

        docker pull roccodonnarumma/airflow-gcp:1.8.0-gcp

## Build

In case you need to customize it, edit the Dockerfile and then build it.

        docker build --rm -t roccodonnarumma/airflow-gcp:1.8.0-gcp .

## Usage

You'll need to setup gcloud command line tool and authenticate.

Run setup.sh to create a Cloud SQL database instance and a service account that will be downloaded locally to be used by the container to access GCP services.

        ./setup.sh [GCP_PROJECT_NAME] [GCP_DATABASE_INSTANCE_NAME]

The service account that is created contains 3 roles:

* BigQuery Data Editor
* BigQuery User
* Storage Object Admin

You can create the Cloud SQL instance and service account manually through the Google Cloud Console.  

Once the above is done, edit the file docker-compose.yml and modify the following environment variables:

* [GCP_PROJECT]
* [GCP_REGION]
* [GCP_DATABASE_INSTANCE_NAME]
* [GCS_BUCKET_ID]

Bring the cluster up:

        docker-compose up -d


## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)
- Flower: [localhost:5555] (http://localhost:5555/)


## Scale the number of workers

Easy scaling using docker-compose:

        docker-compose scale worker=5

This can be used to scale to a multi node setup using kubernetes.
