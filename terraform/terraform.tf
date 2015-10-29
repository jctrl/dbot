provider "aws" {
  access_key = "${var.TERRAFORM_AWS_ACCESS_KEY}"
  secret_key = "${var.TERRAFORM_AWS_SECRET_KEY}"
  region = "${var.region}"
}

module "iam" {
  source = "./modules/aws/iam"
}

module "vpc" {
  source = "./modules/aws/vpc"
  availability = "${var.availability}"
}

module "ec2" {
  source = "./modules/aws/ec2"
  ami = "${lookup(var.amis, var.region)}"
  availability = "${var.availability}"
  instance_type = "${var.instance_type}"
  region = "${var.region}"
  subnet_id = "${module.vpc.subnet_id}"
  security_group = "${module.vpc.security_group}"
  public_key = "${var.AWS_SSH_KEY}"
  instance_profile = "${module.iam.instance_profile}"
}

module "eip" {
  source = "./modules/aws/eip"
  aws_instance = "${module.ec2.aws_instance}"
  aws_internet_gateway = "${module.vpc.internet_gateway}"
}

module "elb" {
  source = "./modules/aws/elb"
  subnets = "${module.vpc.subnet_id}"
  instances = "${module.ec2.aws_instance}"
}

module "ecs" {
  source = "./modules/aws/ecs"
}