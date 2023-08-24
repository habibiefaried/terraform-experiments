resource "aws_key_pair" "my_keypair" {
  key_name   = "my-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvnrAhhfkUj7ueyIZYCovQWi5FQ4TFwyybTVl+EXppkJKYzX1CJHjDoWQt5NlGBCRpSfLnXU1ls1f+4sf96xjVszOc5mvIj4442rwIUscvGkwfAu0NQmEnGGbWOHUANETBUuFxuGxlozLnVy7sxtgCbfMFLBIOnteYnZ/RewtavkvgYUkIPd/UBmw/8kx1/7Ju5U7y5ncvKu4o2ctJPZpebMIPLdvEQLi9QOL2kZsFeg/KRdr558/AJ/hSoWOtUoE5KZ5oDG+070tNi7ZipsUSW1Zsb7NqAwgEh0O9KGWImeKiKKL3zQ7tLn+1aBv0f+ijhaOuYYkFnLddda/bejUR habibiefaried@Habibies-MacBook-Air.local"
}

resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.main.id

  // Inbound rule for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your public IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID for official Ubuntu AMIs
}

module "ec2_instance" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-ec2-instance?ref=v5.3.1"

  name = "single-instance"

  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.my_keypair.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = aws_subnet.public_subnets["ap-southeast-3a"].id
  associate_public_ip_address = true
  availability_zone           = "ap-southeast-3a"
}

output "ec2_public_ip" {
  value = module.ec2_instance.public_ip
}
