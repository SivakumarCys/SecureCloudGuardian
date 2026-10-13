output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "private_instance_id" {
  value = aws_instance.private.id
}
