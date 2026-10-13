resource "aws_config_config_rule" "s3_public_read" {
  name = "${var.project_name}-s3-public-read"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_config_rule" "restricted_ssh" {
  name = "${var.project_name}-restricted-ssh"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}



resource "aws_config_config_rule" "encrypted_ebs" {
  name = "${var.project_name}-encrypted-ebs"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }
}
