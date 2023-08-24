resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Project VPC IG"
  }
  depends_on = [aws_vpc.main]
}

resource "aws_route_table" "igw_routetable" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-rtb"
  }
  depends_on = [aws_vpc.main]
}

resource "aws_route_table_association" "igw_routetable" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.igw_routetable.id
  depends_on     = [aws_route_table.aws_route_table.igw_routetable, aws_internet_gateway.gw]
}

resource "aws_route" "to-firewall-igw" {
  for_each               = local.subnets.public
  route_table_id         = aws_route_table.igw_routetable.id
  destination_cidr_block = local.subnets.public[each.key]
  vpc_endpoint_id        = element([for ss in tolist(aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id if ss.availability_zone == each.key], 0)
  depends_on             = [aws_route_table.igw_routetable]
}
