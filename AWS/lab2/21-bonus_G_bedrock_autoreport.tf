############################################
# Bonus G - Bedrock Auto Incident Report Pipeline (SNS -> Lambda -> S3)
############################################

############################################
# S3 Bucket - Incident Reports Archive
############################################

resource "aws_s3_bucket" "ir_reports_bucket" {
  bucket = "${var.project_name}-ir-reports-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "${var.project_name}-ir-reports"
    Component   = "incident-response"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "ir_reports_pab" {
  bucket                  = aws_s3_bucket.ir_reports_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# IAM Role - Lambda Execution
############################################

resource "aws_iam_role" "ir_lambda_role" {
  name = "${var.project_name}-ir-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

############################################
# IAM Policy - Logs + Bedrock + S3
############################################

resource "aws_iam_policy" "ir_lambda_policy" {
  name = "${var.project_name}-ir-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # CloudWatch Logs analysis
      {
        Effect = "Allow"
        Action = [
          "logs:StartQuery",
          "logs:GetQueryResults",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      },

      # CloudWatch alarms & metrics (read-only)
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      },

      # S3 report storage
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.ir_reports_bucket.arn,
          "${aws_s3_bucket.ir_reports_bucket.arn}/*"
        ]
      },

      # Amazon Bedrock (Claude / Titan)
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ir_lambda_policy_attach" {
  role       = aws_iam_role.ir_lambda_role.name
  policy_arn = aws_iam_policy.ir_lambda_policy.arn
}

############################################
# Lambda Function - Auto Incident Report
############################################

resource "aws_lambda_function" "ir_autoreport_lambda" {
  function_name = "${var.project_name}-ir-autoreport"
  role          = aws_iam_role.ir_lambda_role.arn
  runtime       = "python3.11"
  # handler       = "lambda_function.lambda_handler"
  timeout       = 60

  filename         = "${path.module}/lambda/lambda_ir_reporter.zip"
source_code_hash = filebase64sha256("${path.module}/lambda/lambda_ir_reporter.zip")
handler          = "handler.lambda_handler"


  environment {
    variables = {
      REPORT_BUCKET = aws_s3_bucket.ir_reports_bucket.bucket
      PROJECT_NAME  = var.project_name
    }
  }

  tags = {
    Component = "incident-response"
  }
}

data "aws_caller_identity" "current" {}

############################################
# SNS Trigger - Incident Notifications
############################################

resource "aws_sns_topic" "ir_incident_topic" {
  name = "${var.project_name}-ir-incidents"
}

resource "aws_sns_topic_subscription" "ir_lambda_sub" {
  topic_arn = aws_sns_topic.ir_incident_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ir_autoreport_lambda.arn
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ir_autoreport_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ir_incident_topic.arn
}
