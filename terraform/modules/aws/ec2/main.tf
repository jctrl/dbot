variable "ami" {}
variable "availability" {}
variable "instance_type" {}
variable "region" {}
variable "subnet_id" {}
variable "security_group" {}
variable "public_key" {}
variable "instance_profile" {}

resource "aws_key_pair" "hubot-deployer-us-east" {
  key_name = "hubot-deployer-us-east-key"
  public_key = "${var.public_key}"
}

resource "aws_instance" "hubot-aws-ec2-us-east" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability}"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.hubot-deployer-us-east.key_name}"
  iam_instance_profile = "${var.instance_profile}"
  vpc_security_group_ids = ["${var.security_group}"]
  user_data = "${file("./modules/aws/scripts/config.sh")}"
}

output "aws_instance" {
	value = "${aws_instance.hubot-aws-ec2-us-east.id}"
}