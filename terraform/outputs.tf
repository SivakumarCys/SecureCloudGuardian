output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}
output "internet_gateway_id" {
  value = module.network.internet_gateway_id
}

output "public_route_table_id" {
  value = module.network.public_route_table_id
}
output "bastion_sg_id" {
  value = module.security.bastion_sg_id
}

output "private_sg_id" {
  value = module.security.private_sg_id
}
output "bastion_instance_id" {
  value = module.compute.bastion_instance_id
}

output "private_instance_id" {
  value = module.compute.private_instance_id
}
output "cloudtrail_arn" {
  value = module.monitoring.cloudtrail_arn
}
output "config_role_arn" {
  value = module.config.config_role_arn
}

output "config_recorder_name" {
  value = module.config.config_recorder_name
}
output "guardduty_detector_id" {
  value = module.guardduty.guardduty_detector_id
}
output "securityhub_account_id" {
  value = module.securityhub.securityhub_account_id
}
output "inspector_account_id" {
  value = module.inspector.account_id
}
output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}
output "eventbridge_rule_name" {
  value = module.eventbridge.event_rule_name
}

output "eventbridge_rule_arn" {
  value = module.eventbridge.event_rule_arn
}
output "cloudwatch_log_group" {
  value = module.cloudwatch.log_group_name
}
output "sns_topic_arn" {
  value = module.sns.sns_topic_arn
}
