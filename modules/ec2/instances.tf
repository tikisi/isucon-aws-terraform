locals {
  ssh_keys = distinct([for key in var.ssh_authorized_keys : trimspace(key)])
  user_data = templatefile("${path.module}/cloud-init.tpl", {
    ssh_authorized_keys = local.ssh_keys
  })
}

resource "aws_instance" "participant-instance" {
  ami                         = data.aws_ami.standalone_ami.id
  count                       = length(var.ec2_members)
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]

  root_block_device {
    volume_type           = "standard"
    volume_size           = var.ec2_volume_size
    delete_on_termination = true
  }

  user_data = local.user_data

  tags = {
    Name = format("isucon-%s", lookup(var.ec2_members, count.index))
  }
}
