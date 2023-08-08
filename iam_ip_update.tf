data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_execution_ip_update" {
  name        = "ip_update${var.stage}LambdaExecutionPolicy"
  description = "This policy grants access to all services which are required by ip_update lambda functions."
  policy      = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "s3:Get*",
            "s3:PutObject",
            "s3:CreateBucket",
            "s3:ListBucket",
            "s3:ListAllMyBuckets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets",
            "ec2:DescribeNetworkInterfaces",
            "cloudwatch:putMetricData"
           ],
           "Resource": "*"
       }
   ]
}
POLICY

}

resource "aws_iam_role" "lambda_execution_ip_update" {
  name = "ip_update${var.stage}LambdaExecutionRole"
  description = "Role that is assigned to ip_update Lambda functions."
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_ip_update" {
  role = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}
