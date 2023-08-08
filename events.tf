resource "aws_cloudwatch_event_rule" "trigger_dns_lambda" {
  name                = "dns_lambda_trigger"
  description         = "Triggers the lambda function which will update the DNS record with private ip addresses of the ipUpdateNLB alb"
  schedule_expression = "cron(*/1 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "trigger_dns_lambda" {
  rule = aws_cloudwatch_event_rule.trigger_dns_lambda.name
  arn  = aws_lambda_function.dns.arn
}
