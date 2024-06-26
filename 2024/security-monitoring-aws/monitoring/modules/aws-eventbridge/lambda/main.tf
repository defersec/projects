# Create Eventbridge rule
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  # Don't create a new bus
  create_bus = false

  ### IAM role settings
  # Don't create a new IAM role
  # We have already setup a resource-based polcy
  create_role = false
  attach_lambda_policy = false

  # role_name = "EventBridgeRuleForLambda"
  # role_description = "IAM Role to be attached to the EventBridge rule"
  
  lambda_target_arns = [var.lambda_function_arn]

  # Create a new rule 
  rules = {
    s3_put_object_lambda = {
      description = "Triggers a Lambda function when objects are uploaded to certain S3 bucket"
      event_pattern = jsonencode({
        "source": ["aws.s3"],
        "detail-type": ["AWS API Call via CloudTrail"],
        "detail": {
          "eventSource": ["s3.amazonaws.com"],
          # Specify which actions to look for
          "eventName": ["PutObject", "CompleteMultipartUpload"],
          # Also limit to events to our previously created S3 bucket
          "requestParameters": {
            "bucketName": [var.s3_bucket_name]
          },
        }
      })
    }
  }

  # Create a new Lambda based EventBridge target
  targets = {
    s3_put_object_lambda = {
      lambda_target = {
        arn           = var.lambda_function_arn
        name          = "send-s3-put-events-to-lambda"
      }
    }
  }
}
