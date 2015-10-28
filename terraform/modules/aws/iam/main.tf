resource "aws_iam_instance_profile" "hubot-iam-instance-profile-us-east" {
  name = "hubot-iam-instance-profile-us-east"
  roles =["${aws_iam_role.hubot-ecs-service-iam-role-us-east.name}"]
}

resource "aws_iam_role" "hubot-ecs-service-iam-role-us-east" {
  name = "hubot-ecs-service-iam-role-us-east"
  assume_role_policy = "${file("./modules/aws/iam/policies/ecs/service/iam_role.json")}"
}

resource "aws_iam_role_policy" "hubot-ecs-service-iam-policy-us-east" {
  name = "hubot-ecs-service-iam-policy-us-east"
  role = "${aws_iam_role.hubot-ecs-service-iam-role-us-east.id}"
  policy = "${file("./modules/aws/iam/policies/ecs/service/iam_policy.json")}"
}

resource "aws_iam_role" "hubot-ecs-instance-iam-role-us-east" {
  name = "hubot-ecs-instance-iam-role-us-east"
  path = "/"
  assume_role_policy = "${file("./modules/aws/iam/policies/ecs/instance/iam_role.json")}"
}

resource "aws_iam_role_policy" "hubot-ecs-instance-iam-policy-us-east" {
  name = "hubot-ecs-instance-iam-policy-us-east"
  role = "${aws_iam_role.hubot-ecs-instance-iam-role-us-east.name}"
  policy = "${file("./modules/aws/iam/policies/ecs/instance/iam_policy.json")}"
}

output "iam_role" {
  value = "${aws_iam_role.hubot-ecs-service-iam-role-us-east.arn}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.hubot-iam-instance-profile-us-east.name}"
}