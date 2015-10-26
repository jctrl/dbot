resource "aws_ecs_task_definition" "brosephs-ecs-definition-us-east" {
  family = "brosephs-ecs-family-us-east"
  container_definitions = <<EOF
[
  {
    "name": "brosephs-slackbot",
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
      },{
        "name" : "PORT",
        "value" : "8081"
      }
    ],
    "privileged": true,
    "portMappings": [
      {
        "containerPort": 8081,
        "hostPort": 8081
      }
    ],
    "command" : ["/bin/sh", "-c", "bin/hubot --adapter slack"]
  }
]
EOF
}

resource "aws_ecs_service" "brosephs-ecs-service-us-east" {
  name = "brosephs-service"
  cluster = "${aws_ecs_cluster.dbot-ecs-cluster-us-east.id}"
  task_definition = "${aws_ecs_task_definition.brosephs-ecs-definition-us-east.arn}"
  desired_count = 1

  iam_role = "${aws_iam_role.dbot-ecs-service-iam-role-us-east.arn}"
  depends_on = ["aws_iam_role_policy.dbot-ecs-service-iam-policy-us-east"]

  load_balancer {
    elb_name = "${aws_elb.dbot-elastic-lb-us-east.name}"
    container_name = "brosephs-slackbot"
    container_port = 8081
  }
}