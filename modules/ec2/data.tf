data "aws_ami" "standalone_ami" {
  # 過去の ISUCON 環境を再現するため、deprecated な公開 AMI も検索します。
  include_deprecated = true
  most_recent        = true
  owners             = [var.standalone_ami_owner]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = [format("%s-*", var.standalone_ami_name)]
  }
}
