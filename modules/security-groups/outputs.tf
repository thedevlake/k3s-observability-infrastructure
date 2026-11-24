output "security_group_id" {
  description = "ID of the K3s node security group."
  value       = aws_security_group.k3s_nodes.id
}

output "security_group_name" {
  description = "Name of the K3s node security group."
  value       = aws_security_group.k3s_nodes.name
}
