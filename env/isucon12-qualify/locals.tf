locals {
  common_tags = {
    RepositoryURL = "https://github.com/tikisi/isucon-aws-terraform"
    CommitHash    = data.external.git.result.commit_hash
  }

  standalone_ami_name  = "isucon12-qualify"
  standalone_ami_owner = "839726181030"

  vpc_net_mask        = "10.1.0.0"
  security_group_name = "isucon12-qualify_sg"

  # 1 行に 1 公開鍵。空行・コメント行・重複は除外します。
  ssh_authorized_keys = distinct([
    for line in split("\n", file("${path.module}/authorized_keys")) : trimspace(line)
    if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ])
  access_cidr_blocks = "0.0.0.0/0" # 複数の場合はカンマ区切りで指定

  # ベンチマーカーを含む 4 台を同じ AMI から作成します。
  ec2_members = {
    "0" = "worker-01"
    "1" = "worker-02"
    "2" = "worker-03"
    "3" = "benchmark-instance"
  }
  ec2_instance_type = "t2.micro" # c5.large
  ec2_volume_size   = 20
}

