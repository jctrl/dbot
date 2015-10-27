resource "aws_iam_instance_profile" "dbot-iam-instance-profile-us-east" {
  name = "dbot-iam-instance-profile-us-east"
  roles =["${aws_iam_role.dbot-ecs-service-iam-role-us-east.name}"]
}

resource "aws_iam_role" "dbot-ecs-service-iam-role-us-east" {
  name = "dbot-ecs-service-iam-role-us-east"
  assume_role_policy = "${file("./aws/iam/policies/ecs/service/iam_role.json")}"
}

resource "aws_iam_role_policy" "dbot-ecs-service-iam-policy-us-east" {
  name = "dbot-ecs-service-iam-policy-us-east"
  role = "${aws_iam_role.dbot-ecs-service-iam-role-us-east.id}"
  policy = "${file("./aws/iam/policies/ecs/service/iam_policy.json")}"
}

resource "aws_iam_role" "dbot-ecs-instance-iam-role-us-east" {
  name = "dbot-ecs-instance-iam-role-us-east"
  path = "/"
  assume_role_policy = "${file("./aws/iam/policies/ecs/instance/iam_role.json")}"
}

resource "aws_iam_role_policy" "dbot-ecs-instance-iam-policy-us-east" {
  name = "dbot-ecs-instance-iam-policy-us-east"
  role = "${aws_iam_role.dbot-ecs-instance-iam-role-us-east.name}"
  policy = "${file("./aws/iam/policies/ecs/instance/iam_policy.json")}"
}