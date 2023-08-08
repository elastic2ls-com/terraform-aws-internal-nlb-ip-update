data "aws_iam_policy_document" "instance_assume_role_policy" {
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


resource "aws_iam_policy" "lambda_execution" {
  name        = "ipUpdateNLB${var.stage}LambdaExecutionPolicy"
  description = "This policy grants access to all services which are required by ipUpdateNLB lambda functions."
  policy      = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
            "autoscaling:*",
            "elasticloadbalancing:*",
            "codepipeline:PutJobFailureResult",
            "codepipeline:PutJobSuccessResult",
            "ec2:CreateLaunchTemplate",
            "ec2:CreateLaunchTemplateVersion",
            "ec2:DescribeImages",
            "ec2:DescribeLaunchTemplates",
            "ec2:DescribeLaunchTemplateVersions",
            "ec2:DeregisterImage",
            "ec2:DeleteSnapshot",
            "ec2:DescribeSnapshots",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "sns:Publish",
            "ssm:*"
           ],
           "Resource": "*"
       }
   ]
}
POLICY

}

resource "aws_iam_role" "lambda_execution" {
  name               = "ipUpdateNLB${var.stage}LambdaExecutionRole"
  description        = "Role that is assigned to ipUpdateNLB Lambda functions."
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}


### DNS UPDATE ###

resource "aws_iam_policy" "lambda_dns" {
  name        = "ipUpdateNLB${var.stage}-DNS-LambdaExecutionRole"
  description = "This policy grants access to update dns record of alb with private ip adresses"
  policy      = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
            "ec2:DescribeNetworkInterfaces",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "route53:ChangeResourceRecordSets"
           ],
           "Resource": "*"
       }
   ]
}
POLICY

}

resource "aws_iam_role" "lambda_dns" {
  name               = "ipUpdateNLB${var.stage}-DNS-LambdaExecutionRole"
  description        = "Role that is assigned to Lambda DNS functions."
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_dns" {
  role       = aws_iam_role.lambda_dns.name
  policy_arn = aws_iam_policy.lambda_dns.arn
}
### DNS UPDATE ###
