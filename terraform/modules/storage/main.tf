resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "logs" {
  bucket = "${lower(var.project_name)}-logs-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "${var.project_name}-logs"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logs.arn
      },

      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },

      {
        Sid    = "AWSConfigBucketPermissionsCheck"
        Effect = "Allow"

        Principal = {
          Service = "config.amazonaws.com"
        }

        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logs.arn
      },

      {
        Sid    = "AWSConfigBucketDelivery"
        Effect = "Allow"

        Principal = {
          Service = "config.amazonaws.com"
        }

        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/AWSLogs/123456789012/Config/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }

    ]
  })
}
