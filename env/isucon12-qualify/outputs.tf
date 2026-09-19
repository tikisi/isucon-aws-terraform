output "instance_public_ips" {
  description = "Map of instance names to public IP addresses"
  value       = module.participant-ec2.instance_public_ips
}

output "instance_private_ips" {
  description = "Map of instance names to private IP addresses"
  value       = module.participant-ec2.instance_private_ips
}
