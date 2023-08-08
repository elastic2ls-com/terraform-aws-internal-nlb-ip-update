locals {
  function_name_crontab = "crontab"
  function_name_dns     = "dns"
}


data "archive_file" "crontab" {
  output_path = "${path.module}/dist/${local.function_name_crontab}.zip"
  source_dir  = "${path.module}/src/${local.function_name_crontab}/"
  type        = "zip"
}

resource "aws_lambda_function" "crontab" {
  filename         = data.archive_file.crontab.output_path
  function_name    = local.function_name_crontab
  handler          = "index.lambda_handler"
  role             = aws_iam_role.lambda_execution.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.crontab.output_base64sha256
  timeout          = 30
  memory_size      = 256
}



### DNS UPDATE ###

data "archive_file" "dns" {
  output_path = "${path.module}/dist/${local.function_name_dns}.zip"
  source_dir  = "${path.module}/src/${local.function_name_dns}/"
  type        = "zip"
}

resource "aws_lambda_function" "dns" {
  filename         = data.archive_file.dns.output_path
  function_name    = local.function_name_dns
  handler          = "index.lambda_handler"
  role             = aws_iam_role.lambda_dns.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.dns.output_base64sha256
  timeout          = 30
  memory_size      = 256
  environment {
    variables = {
      ALB_DESCRIPTION_NAME = var.alb_description_name
      ZONE_ID              = var.zone_id
      INTRA_DNS_NAME       = var.intra_dns_name
    }
  }

}
### DNS UPDATE ###
