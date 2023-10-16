data "aws_iam_policy_document" "assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild-role" {
  name               = "nuke-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}