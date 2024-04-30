resource "aws_cloudtrail" "default" {
  # Put these into variables
  name           = var.trail_name
  s3_bucket_name = var.trail_bucket

  # Create trail in organization master account?
  is_organization_trail = false

  # Use a single S3 bucket for all AWS regions
  is_multi_region_trail = true

  # Add global service events
  include_global_service_events = true

  # Send logs to CloudWatch Logs
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_role.arn

  # We also want Data Events for certain services (such as S3 objects)
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    # TODO: Create S3 bucket GitOps style
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::s3-poc-lambda-golang-eventbridge-cloudtrail/"]
    }

    # You can also exclude certain events
    # exclude_management_event_sources = [
    #   "kms.amazonaws.com",
    #   "rdsdata.amazonaws.com"
    # ]
  }

  depends_on = [
    aws_s3_bucket.cloudtrail_bucket
  ]
}
