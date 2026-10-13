output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}
output "dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}
