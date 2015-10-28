variable "subnets" {}
variable "instances" {}

resource "aws_elb" "hubot-elastic-lb-us-east" {
  name = "hubot-elastic-lb-us-east"
  cross_zone_load_balancing = true

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }

  listener {
    instance_port = 8081
    instance_protocol = "http"
    lb_port = 8081
    lb_protocol = "http"
  }

  subnets = ["${var.subnets}"]
  instances = ["${var.instances}"]
}

output "elb_name" {
  value = "${aws_elb.hubot-elastic-lb-us-east.name}"
}