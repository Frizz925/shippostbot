resource "aws_cloudwatch_metric_alarm" "shippostbot_alarm" {
  alarm_name = "shippostbot-alarm"
  namespace = "AWS/Lambda"
  period = "900"
  evaluation_periods = "4"
  metric_name = "Errors"
  statistic = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = "0.5"
  alarm_description = "Monitors ShippostBot errors"
  insufficient_data_actions = []

  tags = {
    App = "ShippostBot"
    Environment = "Production"
    Service = "CloudWatchMetric"
    Role = "Alarm"
  }
}
