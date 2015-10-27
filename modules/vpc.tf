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