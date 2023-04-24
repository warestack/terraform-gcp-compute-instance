#!/bin/bash

# ENV VARIABLES
PROJECT_ID=$1
PROJECT_REGION="us-central1"
SERVICE_ACCOUNT_NAME="terraform-sa"
BUCKET_NAME="terraform-state-$PROJECT_ID"

echo "CHECKING THE ACTIVE CONFIG BEFORE MAKING ANY CHANGE..."
gcloud config set project $PROJECT_ID

echo "CREATING BUCKET..."
gsutil mb -p $PROJECT_ID -l $PROJECT_REGION gs://$BUCKET_NAME

echo "CREATING SERVICE ACCOUNT..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --project $PROJECT_ID

SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "CREATING THE KEY OF THE SERVICE ACCOUNT..."
gcloud iam service-accounts keys create key.json --iam-account=$SERVICE_ACCOUNT_EMAIL

echo "ENABLE ROLES"
gcloud projects add-iam-policy-binding $PROJECT_ID --member='serviceAccount:'$SERVICE_ACCOUNT_EMAIL --role='roles/storage.admin'
gcloud projects add-iam-policy-binding $PROJECT_ID --member='serviceAccount:'$SERVICE_ACCOUNT_EMAIL --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $PROJECT_ID --member='serviceAccount:'$SERVICE_ACCOUNT_EMAIL --role='roles/storage.objectAdmin'

echo "ENABLE SERVICES"

gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable iap.googleapis.com
gcloud services enable compute.googleapis.com

echo "CONFIG PROCESS COMPLETED, ENCODE (BASE64) THE CREATED KEY TO CONTINUE."
