# Create Eventbridge rule
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"
  create_bus = false
  rules = {
    s3_put_object = {
      description = "Triggers when objects are uploaded to certain S3 bucket"
      event_pattern = jsonencode({
        "source": ["aws.s3"],
        "detail-type": ["AWS API Call via CloudTrail"],
        "detail": {
          "eventSource": ["s3.amazonaws.com"], 
          "eventName": ["PutObject", "CompleteMultipartUpload"],
            "requestParameters": {
              "bucketName": [var.s3_bucket_name]
          },
        }
      })
    }
  }
  targets = {
    s3_put_object = {
      example_target = {
        arn           = aws_sns_topic.sns_topic.arn 
        name          = "send-s3-put-events-to-sns-topic"
      }
    }
  }
}

# Create SNS topic
resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic
}
