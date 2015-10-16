#! /bin/bash
cd .terraform
wget https://dl.bintray.com/mitchellh/terraform/terraform_0.6.4_linux_amd64.zip
unzip terraform_0.6.4_linux_amd64.zip
aws s3 cp s3://dla-dbot/.terraform/terraform.tfvars ./
ls -lha
./terraform plan -out=terraform.plan build