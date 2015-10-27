provider "aws" {
  access_key = "${var.TERRAFORM_AWS_ACCESS_KEY}"
  secret_key = "${var.TERRAFORM_AWS_SECRET_KEY}"
  region = "${var.region}"
}

resource "aws_key_pair" "dbot-deployer-us-east" {
  key_name = "dbot-deployer-us-east-key"
  public_key = "${var.AWS_SSH_KEY}"
}

module "iam" {
  source = "./modules/iam"
}

module "elb" {
  source = "./modules/elb"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
}