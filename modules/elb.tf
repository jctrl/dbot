resource "aws_elb" "dbot-elastic-lb-us-east" {
  name = "dbot-elastic-lb-us-east"
  cross_zone_load_balancing = true

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }

  subnets = ["${aws_subnet.dbot-subnet-us-east.id}"]
  instances = ["${aws_instance.dbot-aws-ec2-us-east.id}"]
}