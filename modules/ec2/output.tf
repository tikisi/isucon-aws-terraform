output "instance_public_ips" {
  description = "Map of instance names to public IP addresses"
  value = {
    for instance in aws_instance.participant-instance :
    instance.tags["Name"] => instance.public_ip
  }
}
