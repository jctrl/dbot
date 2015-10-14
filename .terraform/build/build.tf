provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_key_pair" "dbot-deployer-us-east-1" {
  key_name = "dbot-deployer-us-east-1-key"
  public_key = "${var.ssh_key}"
}

resource "aws_iam_role" "dbot-iam-role-us-east-1-tf" {
    name = "dbot-iam-role-us-east-1-tf"
    assume_role_policy = "${var.iam_role}"
}

resource "aws_iam_policy" "dbot-iam-policy-us-east-1-tf" {
  name = "dbot-iam-policy-us-east-1-tf"
  policy = "${var.iam_policy}"
}

resource "aws_ecs_cluster" "dbot-ecs-cluster-us-east-1-tf" {
  name = "dbot-ecs-cluster-us-east-1-tf"
}

resource "aws_ecs_task_definition" "dbot-ecs-definition-us-east-tf" {
  family = "dbot-ecs-family-us-east-1"
  container_definitions = "${file("./build//task-definitions/build.json")}"
}

resource "aws_elb" "dbot-elastic-lb-us-east-1-tf" {
  name = "dbot-elastic-lb-us-east-1-tf"
  availability_zones = ["us-east-1a"]
  cross_zone_load_balancing = true

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  # instances = ["${aws_instance.dbot-aws-ec2-us-east-1-tf.id}"]
}

resource "aws_ecs_service" "dbot-ecs-service-us-east-tf" {
  name = "dbot-service"
  cluster = "${aws_ecs_cluster.dbot-ecs-cluster-us-east-1-tf.id}"
  task_definition = "${aws_ecs_task_definition.dbot-ecs-definition-us-east-tf.arn}"
  desired_count = 1

  # iam_role = "${aws_iam_role.dbot-iam-role-us-east-1-tf.arn}"

  # load_balancer {
  #   elb_name = "${aws_elb.dbot-elastic-lb-us-east-1-tf.name}"
  #   container_name = "dbot-ecs-service-us-east-tf"
  #   container_port = 80
  # }
}

resource "aws_vpc" "dbot-vpc-us-east-1-tf" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "dbot-gateway-us-east-1-tf" {
  vpc_id = "${aws_vpc.dbot-vpc-us-east-1-tf.id}"
}

resource "aws_eip" "dbot-elastic-ip-us-east-1-tf" {
  instance = "${aws_instance.dbot-aws-ec2-us-east-1-tf.id}"
  vpc = true
  depends_on = ["aws_internet_gateway.dbot-gateway-us-east-1-tf"]
}

resource "aws_subnet" "dbot-subnet-us-east-1-tf" {
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.dbot-vpc-us-east-1-tf.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "dbot-aws-ec2-us-east-1-tf" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.dbot-subnet-us-east-1-tf.id}"
  key_name = "${aws_key_pair.dbot-deployer-us-east-1.key_name}"
}

output "aws.ssh_key" {
  value = "${var.ssh_key}"
}


output "aws.vpc" {
  value = "${aws_vpc.dbot-vpc-us-east-1-tf.id}:${aws_vpc.dbot-vpc-us-east-1-tf.cidr_block}"
}

output "aws.subnet" {
  value = "${aws_subnet.dbot-subnet-us-east-1-tf.id}:${aws_subnet.dbot-subnet-us-east-1-tf.cidr_block}"
}

output "aws.ec2.public.dns" {
  value = "${aws_instance.dbot-aws-ec2-us-east-1-tf.public_dns}"
}

output "aws.ec2.public.ip" {
  value = "${aws_instance.dbot-aws-ec2-us-east-1-tf.public_ip}"
}