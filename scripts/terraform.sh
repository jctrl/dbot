#! /bin/bash
cd .terraform
wget https://dl.bintray.com/mitchellh/terraform/terraform_0.6.4_linux_amd64.zip
unzip terraform_0.6.4_linux_amd64.zip
aws s3 cp s3://dla-dbot/.terraform/terraform.tfvars ./
cat terraform.tfvars
./terraform plan -var-file=terraform.tfvars -out=terraform.plan build