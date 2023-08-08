locals {
  function_name = "ip_update"
}

data "archive_file" "ip_update" {
  output_path = "${path.module}/dist/${local.function_name}.zip"
  source_dir  = "${path.module}/src/${local.function_name}/"
  type        = "zip"
}

resource "aws_lambda_function" "ip_update" {
  filename         = data.archive_file.ip_update.output_path
  function_name    = local.function_name
  handler          = "index.lambda_handler"
  role             = aws_iam_role.lambda_execution.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.ip_update.output_base64sha256
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      ALB_DESCRIPTION_NAME = var.alb_description_name
      NLB_TG_ARN           = var.nlb_tg_arn
    }
  }
}
