locals {
  common_tags = {
    RepositoryURL = "https://github.com/tikisi/isucon-aws-terraform"
    CommitHash    = data.external.git.result.commit_hash
  }

  standalone_ami_name  = "isucon14"
  standalone_ami_owner = "839726181030"

  vpc_net_mask        = "10.1.0.0"
  security_group_name = "isucon14"

  # 1 行に 1 公開鍵。空行・コメント行・重複は除外します。
  ssh_authorized_keys = distinct([
    for line in split("\n", file("${path.module}/authorized_keys")) : trimspace(line)
    if trimspace(line) != "" && !startswith(trimspace(line), "#")
  ])
  access_cidr_blocks = "0.0.0.0/0" # 複数の場合はカンマ区切りで指定

  # ベンチマーカーと計測サーバーを含む 5 台を同じ AMI から作成します。
  ec2_members = {
    "0" = "worker-01"
    "1" = "worker-02"
    "2" = "worker-03"
    "3" = "bench"
    "4" = "measure"
  }
  ec2_instance_type = "c5.large" # t3.small
  ec2_volume_size   = 20
}
