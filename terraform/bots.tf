module "brosephs" {
  source = "./modules/bots/brosephs"
  HUBOT_BROSEPHS_SLACK_TOKEN = "${var.HUBOT_BROSEPHS_SLACK_TOKEN}"
  HUBOT_AUTH_ADMIN = "${var.HUBOT_AUTH_ADMIN}"
  HUBOT_YOUTUBE_API_KEY = "${var.HUBOT_YOUTUBE_API_KEY}"
  HUBOT_S3_BRAIN_ACCESS_KEY_ID = "${var.HUBOT_S3_BRAIN_ACCESS_KEY_ID}"
  HUBOT_S3_BRAIN_SECRET_ACCESS_KEY = "${var.HUBOT_S3_BRAIN_SECRET_ACCESS_KEY}"
  HUBOT_S3_BRAIN_BUCKET = "${var.HUBOT_S3_BRAIN_BUCKET}"
  HUBOT_S3_BRAIN_FILE_PATH = "${var.HUBOT_S3_BRAIN_FILE_PATH}"
  iam_role = "${module.iam.iam_role}"
  ecs_cluster = "${module.ecs.ecs_cluster}"
  elb_name = "${module.elb.elb_name}"
}

module "deutsch" {
  source = "./modules/bots/deutsch"
  HUBOT_DEUTSCH_SLACK_TOKEN = "${var.HUBOT_DEUTSCH_SLACK_TOKEN}"
  HUBOT_AUTH_ADMIN = "${var.HUBOT_AUTH_ADMIN}"
  HUBOT_YOUTUBE_API_KEY = "${var.HUBOT_YOUTUBE_API_KEY}"
  HUBOT_S3_BRAIN_ACCESS_KEY_ID = "${var.HUBOT_S3_BRAIN_ACCESS_KEY_ID}"
  HUBOT_S3_BRAIN_SECRET_ACCESS_KEY = "${var.HUBOT_S3_BRAIN_SECRET_ACCESS_KEY}"
  HUBOT_S3_BRAIN_BUCKET = "${var.HUBOT_S3_BRAIN_BUCKET}"
  HUBOT_S3_BRAIN_FILE_PATH = "${var.HUBOT_S3_BRAIN_FILE_PATH}"
  iam_role = "${module.iam.iam_role}"
  ecs_cluster = "${module.ecs.ecs_cluster}"
  elb_name = "${module.elb.elb_name}"
}