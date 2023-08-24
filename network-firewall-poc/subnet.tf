resource "aws_subnet" "public_subnets" {
  for_each          = local.subnets.public
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "public-${each.key}"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "private_subnets" {
  for_each          = local.subnets.private
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
  }

  depends_on = [aws_vpc.main]
}
