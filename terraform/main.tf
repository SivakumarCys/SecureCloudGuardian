module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}
module "ssm" {
  source = "./modules/ssm"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  private_subnet_id = module.network.private_subnet_id
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id

  bastion_sg_id = module.security.bastion_sg_id
  private_sg_id = module.security.private_sg_id

  key_name = "SecureCloudGuardian-Key"
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name = var.project_name
  bucket_name  = module.storage.bucket_name

  instance_id          = module.compute.private_instance_id
  lambda_function_name = module.lambda.lambda_function_name
  sns_topic_arn        = module.sns.sns_topic_arn
  aws_region           = var.aws_region
}

module "config" {
  source = "./modules/config"

  project_name = var.project_name
  bucket_name  = module.storage.bucket_name
}
module "compliance" {
  source = "./modules/compliance"

  project_name = var.project_name
}

module "guardduty" {
  source = "./modules/guardduty"

  project_name = var.project_name
}

module "securityhub" {
  source = "./modules/securityhub"

  aws_region = var.aws_region
}

module "inspector" {
  source = "./modules/inspector"
}

module "sns" {
  source = "./modules/sns"

  email_address = var.email_address
}

module "lambda" {
  source = "./modules/lambda"

  project_name  = var.project_name
  sns_topic_arn = module.sns.sns_topic_arn
  instance_id   = module.compute.private_instance_id
}

module "eventbridge" {
  source = "./modules/eventbridge"

  project_name = var.project_name

  lambda_arn  = module.lambda.lambda_function_arn
  lambda_name = module.lambda.lambda_function_name
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  lambda_function_name = module.lambda.lambda_function_name
}

