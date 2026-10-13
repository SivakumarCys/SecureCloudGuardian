resource "aws_iam_role" "config_role" {
  name = "${var.project_name}-Config-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "config.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}
resource "aws_config_configuration_recorder" "main" {
  name     = "${var.project_name}-Recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = true
  }
}
resource "aws_config_delivery_channel" "main" {
  name           = "${var.project_name}-DeliveryChannel"
  s3_bucket_name = var.bucket_name

  depends_on = [
    aws_config_configuration_recorder.main
  ]
}
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.main
  ]
}
