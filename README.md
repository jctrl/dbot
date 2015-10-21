### Initial infrastructure build

Install [Terraform](https://terraform.io/).

```
cd .terraform
terraform apply
```

To run Hubot with minimal functionality in a local environment:

```
docker build -t dbot .
docker run -e HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN -d dbot
```

### Requirements

- [AWS](https://aws.amazon.com/)
- [Docker](https://www.docker.com/)
- [Terraform](https://terraform.io/)
- An [Atlas]([https://atlas.hashicorp.com/) environment and Github integration (for automated builds)

It is suggested that you create a dedicated IAM profile to manage Terraform with sufficient permissions to move around between [EC2](https://aws.amazon.com/ec2/), [ECS](https://aws.amazon.com/ecs/), [ELB](https://aws.amazon.com/elasticloadbalancing/), [S3](https://aws.amazon.com/s3/) and [VPC](https://aws.amazon.com/vpc/)

### Notes

If you intend on utilizing to use the Terraform configs to release infrastructure into any EC2 instance that's not T2, VPC config rulesets are not required (but they are suggested).

### Releases

Upon issuing a pull request :

- Circle CI verifies the Docker build; we want to make sure the guest of honor can breathe
- Atlas will take the [terraform](https://terraform.io/) files and verify that there are no breaking changes to the them before trying to deploy to AWS.

Atlas will automatically deploy to AWs with no further interaction needed. If both tests pass, make sure to merge with master.

### Updates

If you're changing/adding any additional environment variables to `terraform.tfvars` you will need to push those changes to AWS before pushing changes to Github (how-to below).

Modifications should follow continuous deployment standards at all times.

```
terraform apply
```

### terraform.tfvars

This is what this project's environment variables look like. If you're going to clone and run this repository directly, you'll need these variables at a bare minimum.

File location should be at the root of the project `file-name.tfvars`

```
HUBOT_SLACK_TOKEN = ""
HUBOT_AUTH_ADMIN = ""
HUBOT_YOUTUBE_API_KEY = ""
HUBOT_S3_BRAIN_ACCESS_KEY_ID = ""
HUBOT_S3_BRAIN_SECRET_ACCESS_KEY = ""
TERRAFORM_AWS_ACCESS_KEY = ""
TERRAFORM_AWS_SECRET_KEY = ""
AWS_SSH_KEY = ""
ATLAS_TOKEN = ""
```

Be sure to push *.tfvars to S3 for CircleCI retrieval or the build will fail

Grunt AWS credentials (config/aws.json):

```json
{
    "TERRAFORM_AWS_ACCESS_KEY" : "",
    "TERRAFORM_AWS_SECRET_KEY" : ""
}
```

Path definition of this file is in `grunt/aws.js` & `grunt/config.js`.


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