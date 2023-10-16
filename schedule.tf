resource "aws_cloudwatch_event_rule" "aws-nuke" {
  name                = "aws-nuke-event-rule"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "aws-nuke" {
  rule      = aws_cloudwatch_event_rule.aws-nuke.name
  target_id = "TriggerCodebuildJob"
  arn       = aws_codebuild_project.aws-nuke.arn
  role_arn  = aws_iam_role.codebuild-role.arn
}
