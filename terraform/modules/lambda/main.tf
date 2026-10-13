resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-Lambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "security_response" {

  function_name = "${var.project_name}-SecurityResponse"

  filename         = "${path.root}/../lambda/lambda.zip"
  source_code_hash = filebase64sha256("${path.root}/../lambda/lambda.zip")

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = aws_iam_role.lambda_role.arn

  timeout = 30

  tags = {
    Name = "${var.project_name}-Lambda"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
  environment {
  variables = {
    SNS_TOPIC_ARN = var.sns_topic_arn
    INSTANCE_ID   = var.instance_id
  }
}
}
resource "aws_iam_role_policy" "sns_publish" {
  name = "LambdaSNSPublish"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "sns:Publish"
        ]

        Resource = var.sns_topic_arn
      }
    ]
  })
}
resource "aws_iam_role_policy" "ec2_control" {
  name = "LambdaEC2Control"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
  "ec2:DescribeInstances",
  "ec2:StopInstances",
  "ec2:CreateTags"
]

        Resource = "*"
      }
    ]
  })
}
