resource "aws_codebuild_source_credential" "repository-credentals" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_personal_access_token

  count = var.github_personal_access_token != "" ? 1 : 0
}

resource "aws_codebuild_project" "aws-nuke" {
  name          = "aws-nuke"
  description   = "nuke infrastructure"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "NUKE_VERSION"
      value = var.aws_nuke_version
    }
  }

  source {
    type     = "GITHUB"
    location = var.github_repo_url
  }

  source_version = var.github_repo_branch

  logs_config {
    cloudwatch_logs {
      group_name  = "aws-nuke"
      stream_name = "sandbox"
    }
  }

  tags = {
    Environment = "aws-nuke"
  }
}
