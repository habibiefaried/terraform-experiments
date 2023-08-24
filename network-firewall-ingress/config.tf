provider "aws" {
  region = "ap-southeast-3"
  default_tags {
    tags = {
      environment = "test"
      service     = "infrastructure"
    }
  }
}

terraform {
  required_version = "~> 1.5"

  backend "s3" {
    bucket  = "terraform-state-habibiefaried"
    key     = "infra/vpc"
    region  = "ap-southeast-3"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.0"
    }
  }
}

module "firewall_ingress" {
  source  = "../modules/firewall-ingress"
  vpc     = aws_vpc.main
  subnets = local.subnets
  aws_igw = aws_internet_gateway.gw
}

module "ec2" {
  source    = "../modules/ec2"
  subnet_id = aws_subnet.public_subnets["ap-southeast-3a"].id
  vpc_id = aws_vpc.main.id
}
