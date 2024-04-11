variable "sns_topic" {
  description = "Name for the SNS topic"
  default     = "poc-lambda-golang-eventbridge-cloudtrail"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "s3-poc-lambda-golang-eventbridge-cloudtrail"
}
