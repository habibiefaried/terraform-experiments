resource "aws_networkfirewall_firewall" "firewall" {
  name                = "firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.firewall.arn
  vpc_id              = var.vpc.id

  dynamic "subnet_mapping" {
    for_each = var.subnets.firewall
    content {
      subnet_id = aws_subnet.firewall_subnets[subnet_mapping.key].id
    }
  }

  subnet_change_protection          = false
  firewall_policy_change_protection = false
  delete_protection                 = false
  depends_on                        = [var.vpc, aws_subnet.firewall_subnets, aws_networkfirewall_firewall_policy.firewall]
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

resource "aws_networkfirewall_rule_group" "firewall" {
  capacity = 1000
  name     = "suricata-rules"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc.cidr_block]
        }
      }
    }
    rules_source {
      rules_string = templatefile("${path.module}/suricata.tftpl", {})
    }
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
  }
}
