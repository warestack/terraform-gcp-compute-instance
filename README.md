# terraform-gcp-compute-instance

This is a sample Terraform configuration for creating a compute instance and its VPC network and firewall rules in GCP.
This is the minimum configuration to demonstrate the Continuous Deployment pipeline of any Web application
(e.g. this [flask-app](https://github.com/warestack/gcp-continious-deployment)) on GCP compute instances using Docker
and GitHub workflows.

## Prerequisites

- Gcloud CLI

### Config Gcloud CLI

Be authenticated using the commands below.

```bash
gcloud init
gcloud auth application-default login   
```

### Config GCP project

The `gcp_config.sh` script is used for creating the required resources (GCS bucket and IAM service account) and enabling
the minimum permissions and services to support this repository needs.

Run the following command to process with the configuration of your project:

```bash
./config.sh <project-id>
```

_**Note: This configuration shell script applies the following operations. You can follow the steps below to config the
GCP project instead of using the shell script.**_

#### Create bcs to support remote terraform state on GCP. 

Bucket name must be globally unique. You can use a bucket name that contains the project id e.g. 
`terraform-state-<project_id>`.

```bash
gsutil mb -p <project_id> -l <region> gs://<bucket_name>
```

Enable remote state versioning (optional).

```bash
gsutil versioning set on gs://<bucket_name>
```

#### Google APIs and IAM Roles

1. Create a new service account for Terraform, add a new KEY, download the generated JSON file with the service account
   credentials.

   ```bash
   gcloud iam service-accounts create <serviceAccountName> --project <project_id>
   gcloud iam service-accounts keys create key.json --iam-account=<serviceAccount.email>
   ```

2. Assign required roles to the new service account.

   ```bash
   gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/storage.admin'   
   gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/storage.objectAdmin'   
   gcloud projects add-iam-policy-binding <project_id> --member='serviceAccount:<serviceAccount.email>' --role='roles/compute.admin'
   ```

3. Enable the `Google APIs`. Make sure that gcloud is configured to use the right project.

   ```bash
   gcloud config set project <project_id>
   ```
   
   ```bash
   gcloud services enable compute.googleapis.com
   gcloud services enable cloudresourcemanager.googleapis.com
   gcloud services enable iam.googleapis.com
   gcloud services enable iap.googleapis.com
   ```

## Provision Infra resources using the GitHub workflow

1. Enable GitHub workflows, navigate to the **Actions** page of the repository and enable the main workflow.
2. Encode the content of the Terraform service account JSON file (created and downloaded by config shell script ) in 
   `BASE64` format and store it as a secret named `GCP_TF_SA_CREDS_BASE64` on GitHub, in a new GitHub environment with
   protection rules is preferred. See the following [link](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
   for setting a new GitHub environment. If you do so, make sure that the right environment is defined in the 
   `gcp_tf_plan_and_apply.yaml` workflow.

   ```yaml
    name: Terraform Init, Validate, Plan and Apply
    
    on:
      push:
        branches:
          - 'main'
      release:
        types: [created]
    
    jobs:
      terraform:
        runs-on: ubuntu-latest
        environment: <your_new_environment>
        env:
          tf_version: '0.14.8'
          tf_working_dir: '.'
          tf_bucket_name: ${{ secrets.GCP_BUCKET_NAME }}
          TF_VAR_project_id: ${{ secrets.GCP_PROJECT_ID }}
          TF_VAR_name: ${{ secrets.ENV_PREFIX }}
          TF_VAR_region: ${{ secrets.GCP_REGION }}
          TF_VAR_zone: ${{ secrets.GCP_ZONE }}
        steps:
          # ...workflow-specific steps
   ```

   Echo the encoded value of the key using the following command:
    
   ```bash
   cat key.json | base64
   ```
    
    or using the [base64encode.org](https://www.base64encode.org/) online.

3. Create the `GCP_BUCKET_NAME`, `GCP_PROJECT_ID`, `ENV_PREFIX`, `GCP_REGION` and `GCP_ZONE` on GitHub or set the
   tf_variables directly in the `gcp_tf_plan_and_apply.yaml` workflow as these variables are not confidential. _**Note
   that the environment variables must have the `TF_VAR_` prefix in order to be visible in the Terraform code.**_
4. Push the main branch (`force push` if you have not applied any change) to trigger the workflow. You can use the 
   GitHub workflow status page to monitor the progress of the workflow.

### Destroy all Infra resources using the manual GitHub workflow

Trigger the `Terraform Destroy All Infra Resources` manual workflow using the **Actions** page of the GitHub repository
(check it [here](https://github.com/warestack/terraform-gcp-compute-instance/actions/workflows/gcp_tf_destroy.yaml)) to
destroy all Infra resources. You can use the GitHub workflow status page to monitor the progress of the workflow.

## Provision Infra resources using Terraform CLI

1. Move the credentials (plain json file) of the service account to the root path of the project.        

2. Create the `variables.auto.tfvars` file and set the following variables inside.

    ```bash
    credentials        = "./credentials.json"
    project_id         = "project_id"
    region             = "region"
    zone               = "zone"
    name               = "env_prefix"
    ```
   
3. Initializes a working directory containing Terraform configuration files.

   ```bash
   terraform init
   ```

4. Preview the changes that terraform plans to make to the infra.
   ```bash
   terraform plan
   ```

5. Execute the actions proposed in a Terraform plan to create, update, or destroy infra resources.
   ```bash
   terraform apply
   ```

You can run the following command to destroy all infra resources managed by the Terraform configuration when you
finish with the compute instance.

```bash
terraform destroy
```

The `--auto-approve` option instructs Terraform not to require interactive approval before applying or destroying the
execution plan / infra changes (e.g.`terraform apply --auto-approve`).

You can use the Terraform `-target` option to preview the execution plan or apply the changes to specific resources,
modules, or collections of resources (e.g. `terraform apply -target=module.vpc`).

## For any questions, suggestions, or feature requests

Get in touch with us:

- Email [dimitris@waresatck.io](mailto:dimitris@warestack.io?subject=[GitHub]%20Source%20Han%20Sans),
  [stelios@waresatck.io](mailto:stelios@warestack.io?subject=[GitHub]%20Source%20Han%20Sans)
- [LinkedIn account](https://www.linkedin.com/in/dimitris-kargatzis-1385a2101/)

## License

License under the MIT License (MIT)

Copyright © 2022 [Warestack, ltd](https://github.com/warestack)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
