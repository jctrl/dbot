# dbot
Slack Hubot adapter for AWS ECS

```
docker build -t dbot .
docker run -e HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN -d listenrightmeow/dbot
```

### Terraform

```
terraform apply -var "ssh_key=`cat (.pem location)`" [TASK]
```

```
tf apply -var "ssh_key=`cat ~/.ssh/aws/dbot/dbot-key-pair-us-east-1-tf.pub`" -var "access_key=`echo $TERRAFORM_AWS_ACCESS_KEY`" -var "secret_key=`echo $TERRAFORM_AWS_SECRET_KEY`" build
```