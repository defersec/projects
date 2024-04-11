variable "trail_name" {
  description = "AWS CloudTrail Name"
}

variable "trail_bucket" {
  description = "AWS CloudTrail S3 Bucket to store log data"
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch Log group name for the Cloudtrail logs"
  type        = string
}

variable "cloudwatch_log_retention_days" {
  description = "The retention length for the Cloudwatch logs"
  default     = 5
  type        = number
}
