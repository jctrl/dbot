resource "aws_ecs_task_definition" "dbot-ecs-definition-us-east" {
  family = "dbot-ecs-family-us-east"
  container_definitions = <<EOF
[
  {
    "name": "dbot-slackbot",
    "image": "listenrightmeow/dbot:latest",
    "cpu": 128,
    "memory": 128,
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
      },{
        "name" : "HUBOT_S3_BRAIN_ACCESS_KEY_ID",
        "value" : "${var.HUBOT_S3_BRAIN_ACCESS_KEY_ID}"
      },{
        "name" : "HUBOT_S3_BRAIN_SECRET_ACCESS_KEY",
        "value" : "${var.HUBOT_S3_BRAIN_SECRET_ACCESS_KEY}"
      },{
        "name" : "HUBOT_S3_BRAIN_BUCKET",
        "value" : "${var.HUBOT_S3_BRAIN_BUCKET}"
      },{
        "name" : "HUBOT_S3_BRAIN_FILE_PATH",
        "value" : "${var.HUBOT_S3_BRAIN_FILE_PATH}"
      }
    ],
    "privileged": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "command" : ["/bin/sh", "-c", "bin/hubot --adapter slack"]
  }
]
EOF
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