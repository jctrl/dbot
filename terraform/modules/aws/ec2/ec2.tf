resource "aws_instance" "hubot-aws-ec2-us-east" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability}"
  subnet_id = "${aws_subnet.hubot-subnet-us-east.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.hubot-deployer-us-east.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.hubot-iam-instance-profile-us-east.name}"
  vpc_security_group_ids = ["${aws_security_group.hubot-security-group-us-east.id}"]
  user_data = "${file("./aws/scripts/config.sh")}"
}