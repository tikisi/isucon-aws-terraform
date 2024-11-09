resource "aws_key_pair" "participant-key" {
  key_name   = "isucon_key"
  public_key = file("./modules/credential/tanaka.pub")
}

locals {
  ssh_key_files = fileset("./modules/credential/", "*.pub")
  ssh_keys = [for file in local.ssh_key_files: file("./modules/credential/${file}")]
  user_data = templatefile("./modules/ec2/cloud-init.tpl", {
    ssh_authorized_keys = local.ssh_keys
  })
}

resource "aws_instance" "participant-instance" {
  ami = var.ami_id
  count = length(var.ec2_members)
  instance_type = var.ec2_instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name = aws_key_pair.participant-key.id
  security_groups = [var.security_group_id]

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
