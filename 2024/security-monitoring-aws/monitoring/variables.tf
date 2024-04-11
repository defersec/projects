variable "trail_name" {
  description = "AWS CloudTrail Name"
  default     = "poc-lambda-golang-eventbridge-cloudtrail"
}

variable "trail_bucket" {
  description = "AWS CloudTrail S3 Bucket to store log data"
  default     = "poc-lambda-golang-eventbridge-cloudtrail"
}

variable "cloudwatch_log_group_name" {
  description = "AWS Cloudwatch log group"
  default     = "/security/logs/cloudtrail"
}

variable "sns_topic" {
  description = "The SNS topic"
  default     = "poc-lambda-golang-eventbridge-cloudtrail"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "s3-poc-lambda-golang-eventbridge-cloudtrail"
}
