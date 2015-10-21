This repo serves as the discovery process to set up infrastructure to utilize [Amazon ECS](https://aws.amazon.com/ecs/) and [Docker](https://www.docker.com/).

Terraform was used to scaffold the AWS infrastructure that is required to get an automated containter to production.

CircleCI is utilized to verify docker container integrity, then will call Terraform to launch the infrastructure to AWS.

`terraform destroy` was used many times while discovering how to make this repo work, read their docs relevant to AWS [here](https://terraform.io/docs/providers/aws/index.html).

```
docker build -t dbot .
docker run -e HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN -d listenrightmeow/dbot
```

### Initial infrastructure build

Install [Terraform](https://terraform.io/).

```
cd .terraform
terraform apply -var-file=aws/terraform.tfvars build
```

### terraform.tfvars

Be sure to push *.tfvars to S3 for CircleCI retrieval or the build will fail

```
nvm install
npm i -g grunt-cli
npm i
```

```
nvm use
grunt
```

```
HUBOT_SLACK_TOKEN = "xoxb-XXXXXX-XXXXXX"
HUBOT_AUTH_ADMIN = "XXXXXX"
TERRAFORM_AWS_ACCESS_KEY = "XXXXXX"
TERRAFORM_AWS_SECRET_KEY = "XXXXXX"
AWS_SSH_KEY = "ssh-rsa goes here"
```

### Grunt task

It's suggested that you create an independent IAM account for Terraform access. Update the `grunt/config.js` file with the S3 bucket that is designated to house the .tfvars file. After .tfvar files are created and unique S3 IAM account policies are created, run the `grunt` task to upload S3.

The policy below is what was used for unique S3 bucket access for the Grunt task.

```
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::dla-dbot",
                "arn:aws:s3:::dla-dbot/*"
            ]
        }
    ]
}
```

##### config/aws.json
```
{
	"TERRAFORM_AWS_ACCESS_KEY" : "XXXXXX",
	"TERRAFORM_AWS_SECRET_KEY" : "XXXXXX"
}
```

### Updates

If you're planning on making any changes to any VPC (network tables, elastic ip, etc), any modifications are made to the task definition or if you're adding any new environment variables those changes will need to be pushed to AWS.

```
terraform apply -var-file=aws/terraform.tfvars build
```