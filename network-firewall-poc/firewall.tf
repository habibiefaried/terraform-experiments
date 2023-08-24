resource "aws_networkfirewall_firewall" "firewall" {
  name                = "firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.firewall.arn
  vpc_id              = aws_vpc.main.id

  dynamic "subnet_mapping" {
    for_each = local.subnets.firewall
    content {
      subnet_id = aws_subnet.firewall_subnets[subnet_mapping.key].id
    }
  }

  subnet_change_protection          = false
  firewall_policy_change_protection = false
  delete_protection                 = false
  depends_on                        = [aws_vpc.main, aws_subnet.firewall_subnets, aws_networkfirewall_firewall_policy.firewall]
}

resource "aws_networkfirewall_firewall_policy" "firewall" {
  name = "firewall-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:pass"]

    stateful_default_actions = ["aws:alert_established", "aws:drop_established"]

    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }

    stateful_rule_group_reference {
      priority     = 1
      resource_arn = aws_networkfirewall_rule_group.firewall.arn
    }
  }
}

resource "aws_cloudwatch_log_group" "fw_alert_log_group" {
  depends_on        = [aws_networkfirewall_firewall.firewall]
  name              = "/aws/network-firewall/alert"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "fw_flow_log_group" {
  depends_on        = [aws_networkfirewall_firewall.firewall]
  name              = "/aws/network-firewall/flow"
  retention_in_days = 1
}

resource "aws_networkfirewall_logging_configuration" "firewall" {
  firewall_arn = aws_networkfirewall_firewall.firewall.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_flow_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
  depends_on = [aws_networkfirewall_firewall.firewall]
}

resource "aws_route_table" "firewall_rtb" {
  for_each = local.subnets.public
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "firewall-${each.key}"
  }
  depends_on = [aws_vpc.main]
}

resource "aws_networkfirewall_rule_group" "firewall" {
  capacity = 1000
  name     = "suricata-rules"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [aws_vpc.main.cidr_block]
        }
      }
    }
    rules_source {
      rules_string = templatefile("suricata.tftpl", {})
    }
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
  }
}

resource "aws_route_table_association" "firewall_rtb" {
  for_each       = local.subnets.public
  subnet_id      = aws_subnet.firewall_subnets[each.key].id
  route_table_id = aws_route_table.firewall_rtb[each.key].id
  depends_on     = [aws_subnet.firewall_subnets, aws_route_table.firewall_rtb]
}

resource "aws_route" "to-firewall-firewall-route" {
  for_each               = local.subnets.public
  route_table_id         = aws_route_table.firewall_rtb[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on             = [aws_route_table.firewall_rtb]
}
