output "rule_names" {
  value = [
    aws_config_config_rule.s3_public_read.name,
    aws_config_config_rule.restricted_ssh.name,
    aws_config_config_rule.encrypted_ebs.name,
  ]
}
