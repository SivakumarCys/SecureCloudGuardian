
resource "aws_instance" "bastion" {
  ami                    = "ami-08c99fa57d488ab37"
  instance_type          = "t3.micro"

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]

  associate_public_ip_address = true

  key_name = var.key_name

  tags = {
    Name = "${var.project_name}-Bastion"
  }
}
resource "aws_instance" "private" {
  ami                    = "ami-08c99fa57d488ab37"
  instance_type          = "t3.micro"

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]

  associate_public_ip_address = false

  key_name = var.key_name

  tags = {
    Name = "${var.project_name}-Private-Server"
  }
}

