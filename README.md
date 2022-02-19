# cloud-computing-lab-6-terraform
Infra provisioned by Terraform in Google Cloud

### Prerequisites

* Gcloud CLI
* Kubectl

**Config Gcloud CLI**  
Be authenticated using the commands below.  
*infrastructure is provisioned in `europe-west2` region. You can use your desired region by adjusting the `TF_VAR_region` variable in the main workflow

```bash
gcloud init
gcloud auth application-default login   
```

### Create bcs to support remote terraform state on GCP. 

Bucket name must be globally unique. You can use a bucket name that contains the project id e.g `terraform-state-<project_id>`

```bash
gsutil mb -p <project_id> -c <storage_class> -l <region> gs://<bucket_name>
```

Enable remote state versioning

```bash
gsutil versioning set on gs://<bucket_name>
```

### Google APIs and IAM Roles

1. Create a new service account for Terraform, add a new KEY, download the generated JSON file with the service account credentials.

```bash
gcloud iam service-accounts create <serviceAccountName> --project <project_id>
gcloud iam service-accounts keys create key.json --iam-account=<serviceAccount.email>
```

2.Assign required roles to the new service account
```bash
gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/storage.admin'   
gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/storage.objectAdmin'   
gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/compute.admin'
```

3.Enable the `Google APIs`. Make sure that gcloud is configured with the right project
```bash
gcloud config set project <project_id>
```

```bash
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable iap.googleapis.com
```

### Provision Infra using GitOps

1. Encode the file's content in `BASE64` format and store it as a secret named `GCP_TF_SA_CREDS_BASE64` on GitHub, in a new Github environment with protection rules is preferred. See the following [link](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) for setting a new Github env.
If you do so, make sure that the right environment is defined in the main workflow.

```bash
name: Infra managed by terraform

on:
  push:
    branches:
      - main

jobs:
  deployment:
    runs-on: ubuntu-latest
    environment: <your_new_environment>
    steps:
      - name: provisioning
        # ...provisioning-specific steps
```

```bash
cat key.json | base64
```
or using the [base64encode.org](https://www.base64encode.org/) online

2. Set the required tf_variables in the main workflow. **Note** variables that starts with TF_VAR_ are visible to the Terraform code only.            


3. Push your changes. You can use the Github workflow status page to monitor the progress of the workflow.

### Provision Infra using Terraform

1. Move the credentials (plain json file) of the service account to the root path of the project         


2. Create the `variables.auto.tfvars` file and set the following variables inside

```bash
credentials        = "./credentials.json"
project_id         = "project_id"
region             = "region"
name               = "workspace_name"
```

### Terraform usage

```bash
# Fetch terraform resources
terraform init

# Check the execution plan
terraform plan

# Apply changes
terraform apply

# Destroy Infrastructure
terraform destroy
```

The `--auto-approve` option tells Terraform not to require interactive approval of the plan before applying it e.g `terraform apply --auto-approve`

### For any questions, suggestions, or feature requests

Get in touch with me on LinkedIn:
- [LinkedIn account](https://www.linkedin.com/in/dimitris-kargatzis-1385a2101/)

### License

License under the MIT License (MIT)

Copyright © 2022 [Dimitris Kargatzis](https://www.linkedin.com/in/dimitris-kargatzis-1385a2101/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
