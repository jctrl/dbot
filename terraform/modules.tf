module "deutsch" {
  source = "./modules/bots/deutsch"
  prefix = "dbot"
  HUBOT_S3_BRAIN_FILE_PATH = "brain/deutsch.json"
}

module "brosephs" {
  source = "./modules/bots/brosephs"
  prefix = "brosephs"
  HUBOT_S3_BRAIN_FILE_PATH = "brain/brosephs.json"
}