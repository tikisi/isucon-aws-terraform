#cloud-config
${yamlencode({
  users = [
    "default",
    {
      name                = "isucon"
      ssh_authorized_keys = ssh_authorized_keys
    }
  ]
})}
