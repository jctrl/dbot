provider "aws" {
  access_key = "${var.TERRAFORM_AWS_ACCESS_KEY}"
  secret_key = "${var.TERRAFORM_AWS_SECRET_KEY}"
  region = "${var.region}"
}

resource "aws_key_pair" "dbot-deployer-us-east" {
  key_name = "dbot-deployer-us-east-key"
  public_key = "${var.AWS_SSH_KEY}"
}

resource "aws_iam_instance_profile" "dbot-iam-instance-profile-us-east" {
  name = "dbot-iam-instance-profile-us-east"
  roles =["${aws_iam_role.dbot-ecs-service-iam-role-us-east.name}"]
}

resource "aws_iam_role" "dbot-ecs-service-iam-role-us-east" {
  name = "dbot-ecs-service-iam-role-us-east"
  assume_role_policy = "${file("./build//iam/policies/ecs/service/iam_role.json")}"
}

resource "aws_iam_role_policy" "dbot-ecs-service-iam-policy-us-east" {
  name = "dbot-ecs-service-iam-policy-us-east"
  role = "${aws_iam_role.dbot-ecs-service-iam-role-us-east.id}"
  policy = "${file("./build//iam/policies/ecs/service/iam_policy.json")}"
}

resource "aws_iam_role" "dbot-ecs-instance-iam-role-us-east" {
  name = "dbot-ecs-instance-iam-role-us-east"
  path = "/"
  assume_role_policy = "${file("./build//iam/policies/ecs/instance/iam_role.json")}"
}

resource "aws_iam_role_policy" "dbot-ecs-instance-iam-policy-us-east" {
  name = "dbot-ecs-instance-iam-policy-us-east"
  role = "${aws_iam_role.dbot-ecs-instance-iam-role-us-east.name}"
  policy = "${file("./build//iam/policies/ecs/instance/iam_policy.json")}"
}

resource "aws_ecs_cluster" "dbot-ecs-cluster-us-east" {
  name = "dbot-ecs-cluster-us-east"
}

resource "aws_ecs_task_definition" "dbot-ecs-definition-us-east" {
  family = "dbot-ecs-family-us-east"
  container_definitions = <<EOF
[
  {
    "name": "dbot-redis",
    "image": "redis",
    "cpu": 1024,
    "memory": 3072,
    "privileged": true
  },
  {
    "name": "dbot-slackbot",
    "image": "listenrightmeow/dbot:latest",
    "cpu": 512,
    "memory": 512,
    "environment": [
      {
        "name" : "HUBOT_SLACK_TOKEN",
        "value" : "${var.HUBOT_SLACK_TOKEN}"
      },{
        "name" : "HUBOT_AUTH_ADMIN",
        "value" : "${var.HUBOT_AUTH_ADMIN}"
      },{
        "name" : "HUBOT_STANDUP_PREPEND",
        "value" : "@group: "
      },{
        "name" : "HUBOT_YOUTUBE_API_KEY",
        "value" : "${var.HUBOT_YOUTUBE_API_KEY}"
      },{
        "name" : "HUBOT_YOUTUBE_DETERMINISTIC_RESULTS",
        "value" : "true"
      }
    ],
    "privileged": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "links": ["dbot-redis:redis"]
  }
]
EOF
}

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

resource "aws_ecs_service" "dbot-ecs-service-us-east" {
  name = "dbot-service"
  cluster = "${aws_ecs_cluster.dbot-ecs-cluster-us-east.id}"
  task_definition = "${aws_ecs_task_definition.dbot-ecs-definition-us-east.arn}"
  desired_count = 1

  iam_role = "${aws_iam_role.dbot-ecs-service-iam-role-us-east.arn}"
  depends_on = ["aws_iam_role_policy.dbot-ecs-service-iam-policy-us-east"]

  load_balancer {
    elb_name = "${aws_elb.dbot-elastic-lb-us-east.name}"
    container_name = "dbot-slackbot"
    container_port = 8080
  }
}

resource "aws_vpc" "dbot-vpc-us-east" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "dbot-gateway-us-east" {
  vpc_id = "${aws_vpc.dbot-vpc-us-east.id}"
}

resource "aws_route_table" "dbot-route-table-us-east" {
  vpc_id = "${aws_vpc.dbot-vpc-us-east.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dbot-gateway-us-east.id}"
  }
}

resource "aws_security_group" "dbot-security-group-us-east" {
  name = "dbot-security-group-us-east"
  vpc_id = "${aws_vpc.dbot-vpc-us-east.id}"

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3389
    to_port = 3389
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 49152
    to_port = 65535
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 49152
    to_port = 65535
  }
}

resource "aws_network_acl" "dbot-network-acl-us-east" {
  vpc_id = "${aws_vpc.dbot-vpc-us-east.id}"

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
  }

  ingress {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  ingress {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 3389
    to_port = 3389
  }

  ingress {
    protocol = "tcp"
    rule_no = 140
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 49152
    to_port = 65535
  }

  egress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 8080
    to_port = 8080
  }

  egress {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }

  egress {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 49152
    to_port = 65535
  }
}

resource "aws_eip" "dbot-elastic-ip-us-east" {
  instance = "${aws_instance.dbot-aws-ec2-us-east.id}"
  vpc = true
  depends_on = ["aws_internet_gateway.dbot-gateway-us-east"]
}

resource "aws_subnet" "dbot-subnet-us-east" {
  availability_zone = "${var.availability}"
  map_public_ip_on_launch = true
  vpc_id = "${aws_vpc.dbot-vpc-us-east.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_route_table_association" "dbot-route-table-association-us-east" {
  subnet_id = "${aws_subnet.dbot-subnet-us-east.id}"
  route_table_id = "${aws_route_table.dbot-route-table-us-east.id}"
}

resource "aws_instance" "dbot-aws-ec2-us-east" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability}"
  subnet_id = "${aws_subnet.dbot-subnet-us-east.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.dbot-deployer-us-east.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dbot-iam-instance-profile-us-east.name}"
  vpc_security_group_ids = ["${aws_security_group.dbot-security-group-us-east.id}"]
  user_data = "${file("./build//scripts/config.sh")}"
}