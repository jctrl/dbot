#! /bin/bash
cd .terraform
aws s3 cp s3://dla-dbot/.terraform/terraform.tfvars ./
./terraform plan -out=terraform.plan build