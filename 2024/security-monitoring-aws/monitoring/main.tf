# Create Cloudtrail
module "aws-cloudtrail" {
  source = "./modules/aws-cloudtrail"

  # Provide parameters to module
  trail_name             = var.trail_name
  trail_bucket           = var.trail_bucket
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
}

# Create EventBridge for SNS
module "aws-eventbridge-sns" {
  source = "./modules/aws-eventbridge/sns"

  sns_topic             = var.sns_topic
  s3_bucket_name        = var.s3_bucket_name
}

# Create EventBridge for Lambda
module "aws-eventbridge-Lambda" {
  source = "./modules/aws-eventbridge/lambda"

  s3_bucket_name        = var.s3_bucket_name
  lambda_function_arn   = aws_lambda_function.cloudtrail-events-parser.arn
}
