resource "aws_route_table_association" "public_subnet_rtb" {
  for_each       = local.subnets.public
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_rtb[each.key].id
  depends_on     = [aws_subnet.public_subnets]
}

resource "aws_route_table" "public_rtb" {
  for_each = local.subnets.public
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "public-${each.key}"
  }
  depends_on = [aws_vpc.main]
}

resource "aws_route" "igw-public-route" {
  for_each               = local.subnets.public
  route_table_id         = aws_route_table.public_rtb[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = element([for ss in tolist(module.firewall_ingress.aws_networkfirewall.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.availability_zone == each.key], 0)
  depends_on             = [aws_route_table.public_rtb, module.firewall_ingress.aws_networkfirewall]
}
