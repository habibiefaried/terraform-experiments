resource "aws_key_pair" "my_keypair" {
  key_name   = "${var.instance_name}-my-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvnrAhhfkUj7ueyIZYCovQWi5FQ4TFwyybTVl+EXppkJKYzX1CJHjDoWQt5NlGBCRpSfLnXU1ls1f+4sf96xjVszOc5mvIj4442rwIUscvGkwfAu0NQmEnGGbWOHUANETBUuFxuGxlozLnVy7sxtgCbfMFLBIOnteYnZ/RewtavkvgYUkIPd/UBmw/8kx1/7Ju5U7y5ncvKu4o2ctJPZpebMIPLdvEQLi9QOL2kZsFeg/KRdr558/AJ/hSoWOtUoE5KZ5oDG+070tNi7ZipsUSW1Zsb7NqAwgEh0O9KGWImeKiKKL3zQ7tLn+1aBv0f+ijhaOuYYkFnLddda/bejUR habibiefaried@Habibies-MacBook-Air.local"
}
