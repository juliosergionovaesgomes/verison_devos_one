# CloudWatch Log Group for general application logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/application/verison-devos-one"
  retention_in_days = 7

  tags = {
    Name        = "verison-devos-one-logs"
    Environment = "localstack"
  }
}