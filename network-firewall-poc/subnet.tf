resource "aws_subnet" "public_subnets" {
  for_each          = local.subnets.public
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "public-${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = local.subnets.private
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
  }
}

resource "aws_subnet" "firewall_subnets" {
  for_each          = local.subnets.firewall
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "firewall-${each.key}"
  }
}
