To Run this config, you need to have a Google Cloud Project
and a Service Account with the following roles: ***

0. Install gcloud and create a project. Authenticate with gcloud.
1. Install Terraform. https://developer.hashicorp.com/terraform/install?product_intent=terraform
2. Add `terraform.tfvars`:
```
project_id = "your-google-cloud-project"
region     = "eu-west1"
```
3. Enable API's in gcloud:
```
gcloud services enable compute.googleapis.com \
  container.googleapis.com \
  redis.googleapis.com \
  --project=study-k8s-435214
```
`gcloud services enable servicenetworking.googleapis.com --project=study-k8s-435214`

If it not applied check web interface or run it one by one.

4. Run the following commands:
```
terraform init
terraform plan
terraform apply
```

# TODO

1. Delete .tfstate and move it to safe place
