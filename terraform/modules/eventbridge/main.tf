resource "aws_cloudwatch_event_rule" "guardduty" {
  name        = "${var.project_name}-GuardDuty-Rule"
  description = "Trigger Lambda when GuardDuty detects findings"

  event_pattern = jsonencode({
    source = [
      "aws.guardduty"
    ]

    detail-type = [
      "GuardDuty Finding"
    ]
  })
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.guardduty.name
  arn  = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty.arn
}
