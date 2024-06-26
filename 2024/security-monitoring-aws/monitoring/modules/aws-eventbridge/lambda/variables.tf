variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "s3-poc-lambda-golang-eventbridge-cloudtrail"
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda function"
  type = string
}
