variable "ssh_key" {}
variable "access_key" {}
variable "secret_key" {}

variable "region" {
	default = "us-east-1"
}

variable "key_name" {
	default = "dbot-deployer-us-east-1-key"
}

variable "instance_type" {
	default = "t2.medium"
}

variable "amis" {
	default = {
		us-east-1 = "ami-4fe4852a"
	}
}

variable "iam_role" {
	default = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Principal": {
				"Service": "ec2.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
		}
	]
}
EOF
}

variable "iam_policy" {
	default = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "*",
			"Resource": "*"
		}
	]
}
EOF
}