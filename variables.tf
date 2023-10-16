variable "aws_nuke_version" {
  type    = string
  default = "v2.25.0"
}

variable "schedule" {
  type    = string
  default = "daily"
}

variable "github_personal_access_token" {
  type    = string
  default = ""
}

variable "github_repo_url" {
  type = string
}

variable "github_repo_branch" {
  type    = string
  default = "main"
}
