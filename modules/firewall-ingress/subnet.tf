resource "aws_subnet" "firewall_subnets" {
  for_each          = var.subnets.firewall
  vpc_id            = var.vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "firewall-${each.key}"
  }

  depends_on = [var.vpc]
}
