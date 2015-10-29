variable "HUBOT_SLACK_TOKEN" {}
variable "HUBOT_AUTH_ADMIN" {}
variable "HUBOT_YOUTUBE_API_KEY" {}
variable "HUBOT_S3_BRAIN_ACCESS_KEY_ID" {}
variable "HUBOT_S3_BRAIN_SECRET_ACCESS_KEY" {}
variable "HUBOT_S3_BRAIN_BUCKET" {}
variable "HUBOT_S3_BRAIN_FILE_PATH" {}
variable "iam_role" {}
variable "ecs_cluster" {}
variable "elb_name" {}

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
        "name" : "PORT",
        "value" : "8080"
      },{
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
        "value" : "brain/deutsch.json"
      }
    ],
    "privileged": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "command": ["/bin/sh", "-c", "bin/hubot --adapter slack"]
  }
]
EOF
}

resource "aws_ecs_service" "hubot-deutsch-ecs-service-us-east" {
  name = "dbot-service"
  cluster = "${var.ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.dbot-ecs-definition-us-east.arn}"
  desired_count = 1

  iam_role = "${var.iam_role}"
  # depends_on = ["${var.iam_role_policy}"]

  load_balancer {
    elb_name = "${var.elb_name}"
    container_name = "dbot-slackbot"
    container_port = 8080
  }
}