output "instance_public_ips" {
  description = "Map of instance names to public IP addresses"
  value       = module.participant-ec2.instance_public_ips
}
