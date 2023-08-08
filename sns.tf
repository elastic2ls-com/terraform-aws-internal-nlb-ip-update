resource "aws_sns_topic" "lambda" {
  name = "ipUpdateNLB-${var.stage}-lambda"
}
