resource "aws_ecs_cluster" "hubot-ecs-cluster-us-east" {
  name = "hubot-ecs-cluster-us-east"
}

output "ecs_cluster" {
  value = "${aws_ecs_cluster.hubot-ecs-cluster-us-east.id}"
}