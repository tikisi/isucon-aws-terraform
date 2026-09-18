variable "standalone_ami_name" {}
variable "standalone_ami_owner" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "ec2_members" {}
variable "ec2_instance_type" {}
variable "ec2_volume_size" {}

variable "ssh_authorized_keys" {
  type = list(string)
  validation {
    condition     = length(var.ssh_authorized_keys) > 0
    error_message = "authorized_keys に公開鍵を少なくとも 1 行登録してください。"
  }
}
