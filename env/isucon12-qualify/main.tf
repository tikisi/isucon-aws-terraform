terraform {
  required_version = ">= 1.16.3, < 2.0.0"

  backend "s3" {
    bucket = "tikisi-terraform-state"
    key    = "isucon-aws-terraform/isucon12-qualify/terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.65"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = local.common_tags
  }
}


module "vpc" {
  source       = "../../modules/vpc"
  vpc_net_mask = local.vpc_net_mask
}

module "subnet" {
  source         = "../../modules/subnet"
  vpc_net_mask   = local.vpc_net_mask
  vpc_id         = module.vpc.vpc_id
  route_table_id = module.vpc.route_table_id
}

module "sg" {
  source      = "../../modules/security_group"
  name        = local.security_group_name
  vpc_id      = module.vpc.vpc_id
  cidr_blocks = split(",", local.access_cidr_blocks)
}

module "participant-ec2" {
  source               = "../../modules/ec2"
  standalone_ami_name  = local.standalone_ami_name
  standalone_ami_owner = local.standalone_ami_owner
  subnet_id            = module.subnet.subnet_id
  security_group_id    = module.sg.security_group_id
  ec2_members          = local.ec2_members
  ec2_instance_type    = local.ec2_instance_type
  ec2_volume_size      = local.ec2_volume_size
  ssh_authorized_keys  = local.ssh_authorized_keys
}
