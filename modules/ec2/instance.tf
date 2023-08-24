module "ec2_instance" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-ec2-instance?ref=v5.3.1"

  name = "single-instance"

  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.my_keypair.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  availability_zone           = "ap-southeast-3a"
}
