resource "aws_security_group" "ssm_endpoint" {
  name        = "${var.project_name}-SSM-Endpoint-SG"
  description = "Security Group for SSM VPC Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-SSM-Endpoint-SG"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-south-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-SSM"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-south-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-SSMMessages"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-south-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [var.private_subnet_id]
  security_group_ids  = [aws_security_group.ssm_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-EC2Messages"
  }
}
