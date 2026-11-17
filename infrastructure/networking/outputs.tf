output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = module.networking.public_subnet_id
}

output "security_group_id" {
  description = "ID of the K3s node security group."
  value       = module.security_groups.security_group_id
}
