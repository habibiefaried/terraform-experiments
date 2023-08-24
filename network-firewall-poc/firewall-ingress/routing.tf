resource "aws_route_table" "firewall_rtb" {
  for_each = var.subnets.public
  vpc_id   = var.vpc.id
  tags = {
    Name = "firewall-${each.key}"
  }
  depends_on = [var.vpc]
}

resource "aws_route_table_association" "firewall_rtb" {
  for_each       = var.subnets.public
  subnet_id      = aws_subnet.firewall_subnets[each.key].id
  route_table_id = aws_route_table.firewall_rtb[each.key].id
  depends_on     = [aws_subnet.firewall_subnets, aws_route_table.firewall_rtb]
}

resource "aws_route" "to-fw-route" {
  for_each               = var.subnets.public
  route_table_id         = aws_route_table.firewall_rtb[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.aws_igw.id
  depends_on             = [aws_route_table.firewall_rtb, var.aws_igw]
}
