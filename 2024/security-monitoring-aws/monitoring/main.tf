# Create Cloudtrail
module "aws-cloudtrail" {
  source = "./modules/aws-cloudtrail"

  # Provide parameters to module
  trail_name             = var.trail_name
  trail_bucket           = var.trail_bucket
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
}

# Create Cloudtrail
module "aws-eventbridge-sns" {
  source = "./modules/aws-eventbridge/sns"

  sns_topic             = var.sns_topic
  s3_bucket_name        = var.s3_bucket_name
}
