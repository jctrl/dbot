# dbot
Slack Hubot adapter for AWS ECS

```
docker build -t dbot .
docker run -e HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN -d listenrightmeow/dbot
```

### Terraform

```
terraform apply [TASK]
```