module "brosephs" {
	source = "./modules/brosephs.tf"
	HUBOT_S3_BRAIN_FILE_PATH = "brain/brosephs/dump.json"
}