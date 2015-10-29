variable "aws_instance" {}
variable "aws_internet_gateway" {}

resource "aws_eip" "hubot-elastic-ip-us-east" {
  instance = "${var.aws_instance}"
  vpc = true
}