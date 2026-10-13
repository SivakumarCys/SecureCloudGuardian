resource "aws_sns_topic" "security_alerts" {
  name = "SecureCloudGuardian-SecurityAlerts"

  tags = {
    Name = "SecureCloudGuardian-SNS"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.email_address
}
