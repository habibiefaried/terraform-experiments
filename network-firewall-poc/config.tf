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
  source  = "./firewall-ingress"
  vpc     = aws_vpc.main
  subnets = local.subnets
  aws_igw = aws_internet_gateway.gw
}
