output "bastion_instance_id" {
  description = "EC2 instance ID of the bastion host."
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "app_instance_id" {
  description = "EC2 instance ID of the application server."
  value       = aws_instance.app.id
}

output "app_private_ip" {
  description = "Private IP address of the application server."
  value       = aws_instance.app.private_ip
}

output "bastion_key_name" {
  description = "AWS key pair name used by the bastion host."
  value       = aws_key_pair.bastion.key_name
}

output "app_key_name" {
  description = "AWS key pair name used by the application server."
  value       = aws_key_pair.app.key_name
}

output "bastion_key_pem_path" {
  description = "Local filesystem path to the bastion private key PEM file."
  value       = local_file.bastion_pem.filename
}

output "app_key_pem_path" {
  description = "Local filesystem path to the app server private key PEM file."
  value       = local_file.app_pem.filename
}
