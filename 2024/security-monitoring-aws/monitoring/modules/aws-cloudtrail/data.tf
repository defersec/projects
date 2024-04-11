# The AWS account id
data "aws_caller_identity" "current" {}

# The AWS region currently being used.
data "aws_region" "current" {}

# The AWS partition
data "aws_partition" "current" {}

# The currrent organization
# data "aws_organizations_organization" "current" {}

# Cloudtrail assume role
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

# This role is used by CloudTrail to send logs to CloudWatch.
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name               = "CloudtrailIAMRole"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}

# Allow Cloudtrail to send logs to Cloudwatch
data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    sid    = "WriteCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}:*"]
  }
}

# Policy to be attached to the role
resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  name   = "CloudtrailCloudwatchLogsPolicy"
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}

# Attach the policy to a role
resource "aws_iam_policy_attachment" "attach_policy_logs" {
  name       = "CloudtrailCloudwatchLogsPolicy-attachment"
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs.arn
  roles      = [aws_iam_role.cloudtrail_cloudwatch_role.name]
}

# Bucket policy for the Cloudtrail S3 bucket
data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  # Allow to fetch bucket ACLs
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::${var.trail_bucket}",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.trail_name}}"]
    }
  }

  # Allow Cloudtrail to put logs into S3 bucket
  statement {
    sid    = "AWSCloudTrailWriteAccount"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.trail_bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    # Conditions
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${var.trail_name}"]
    }
  }
}
