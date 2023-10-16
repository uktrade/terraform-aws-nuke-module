# Terraform-aws-nuke-module

## Usage

1. Create a github repository and add a codebuild `buildspec .yml` and a `nuke-config.yml` file.

**buildspec.yml**

```yaml
version: 0.2

phases:
  install: 
    commands:
      - wget -q https://github.com/rebuy-de/aws-nuke/releases/download/${NUKE_VERSION}/aws-nuke-${NUKE_VERSION}-linux-amd64.tar.gz
      - tar xvf aws-nuke-${NUKE_VERSION}-linux-amd64.tar.gz
      - mv aws-nuke-${NUKE_VERSION}-linux-amd64 aws-nuke
      - chmod u+x aws-nuke
  build: 
    commands:
      - ./aws-nuke --force --force-sleep 1 --quiet -c nuke-config.yml 
```

> Note: aws-nuke is in dry-mode by default. To nuke infrastructure add the `--no-dry-run` flag.

**nuke-config.yml**

```yaml
#  aws-nuke config for the sandbox account

regions:
- eu-west-2
- global

# This is required
account-blocklist:
- "999999999999"

accounts:
  "111111111111":  # Replace with the account ID
    presets:
    - exclude_nuke_resources

presets:
  # Exclude infrastructure created by terraform-aws-nuke-module
  exclude_nuke_resources:
    filters:
    # Role/ role policy attachment / 
      CodeBuildProject:
      - "aws-nuke"
      CloudWatchLogsLogGroup:
      - property: logGroupName
        value: "aws-nuke"
```

2. Create a terraform project 

```hcl
provider "aws" {
[...]
}

module "nuke" {
  source = "https://github.com/uktrade/terraform-aws-nuke-module"

  # only needed for private github repos
  github_personal_access_token = "a-secret-key"

  github_repo_url = "https://github.com/someuser/nuke-config.git"
  github_repo_branch = "main"
  aws_nuke_version = "v2.25.0"
  # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-cron-expressions.html
  schedule = "cron(0 0 ? * FRI *)"  # Run every Friday at 00:00 UTC
}

```
