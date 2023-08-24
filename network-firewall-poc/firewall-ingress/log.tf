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
  depends_on = [
    aws_networkfirewall_firewall.firewall,
    aws_cloudwatch_log_group.fw_flow_log_group,
    aws_cloudwatch_log_group.fw_alert_log_group
  ]
}
