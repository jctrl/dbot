variable "HUBOT_SLACK_TOKEN" {}
variable "HUBOT_AUTH_ADMIN" {}
variable "TERRAFORM_AWS_ACCESS_KEY" {}
variable "TERRAFORM_AWS_SECRET_KEY" {}
variable "AWS_SSH_KEY" {}

variable "region" {
	default = "us-east-1"
}

variable "key_name" {
	default = "dbot-deployer-us-east-1-key"
}

variable "instance_type" {
	default = "t2.micro"
}

variable "amis" {
	default = {
		us-east-1 = "ami-4fe4852a"
	}
}

variable "availability" {
	default = "us-east-1a"
}