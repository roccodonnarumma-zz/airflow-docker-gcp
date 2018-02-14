gcloud sql instances create $2 --database-version MYSQL_5_7 --region us-central1

rm -rf iam/
mkdir iam

gcloud iam service-accounts create airflow-service-account --display-name=airflow-service-account
gcloud iam service-accounts keys create iam/service-account.json --iam-account=airflow-service-account@$1.iam.gserviceaccount.com

chmod 777 iam/service-account.json

gcloud projects add-iam-policy-binding gcp-rocco --member=serviceAccount:airflow-service-account@$1.iam.gserviceaccount.com --role=roles/bigquery.dataEditor
gcloud projects add-iam-policy-binding gcp-rocco --member=serviceAccount:airflow-service-account@$1.iam.gserviceaccount.com --role=roles/bigquery.user
gcloud projects add-iam-policy-binding gcp-rocco --member=serviceAccount:airflow-service-account@$1.iam.gserviceaccount.com --role=roles/bigquery.admin
gcloud projects add-iam-policy-binding gcp-rocco --member=serviceAccount:airflow-service-account@$1.iam.gserviceaccount.com --role=roles/storage.objectAdmin
