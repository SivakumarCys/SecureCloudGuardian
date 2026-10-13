resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-trail"
  s3_bucket_name                = var.bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}
resource "aws_cloudwatch_dashboard" "main" {

  dashboard_name = "${var.project_name}-Dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "EC2 CPU Utilization"

          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              var.instance_id
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.aws_region
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title = "Lambda Invocations"

          metrics = [
            [
              "AWS/Lambda",
              "Invocations",
              "FunctionName",
              var.lambda_function_name
            ]
          ]

          stat   = "Sum"
          period = 300
          region = var.aws_region
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name          = "${var.project_name}-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 300
  statistic = "Average"

  threshold = 70

  alarm_description = "CPU utilization is above 70%"

  alarm_actions = [var.sns_topic_arn]

  dimensions = {
    InstanceId = var.instance_id
  }
}
