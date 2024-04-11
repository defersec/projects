output "cloudtrail_instance" {
  description = "Cloudtrail instance"
  value       = aws_cloudtrail.default
}
output "cloudtrail_s3_bucket" {
  description = "Cloudtrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail_bucket
}
