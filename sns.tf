resource "aws_sns_topic" "lambda" {
  name = "ipUpdateNLB-${var.stage}-lambda"
  kms_master_key_id = aws_kms_key.ip_update.key_id
}

resource "aws_kms_key" "ip_update" {
  description             = "sns-encrpytion"
}