variable "aws_instance" {}

resource "aws_eip" "hubot-elastic-ip-us-east" {
  instance = "${var.aws_instance}"
  vpc = true
  # depends_on = ["aws_internet_gateway.hubot-gateway-us-east"]
}