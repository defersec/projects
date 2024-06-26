# Create Lambda function
resource "aws_lambda_function" "cloudtrail-events-parser" {
  function_name = "cloudtrail-events-parser"
  timeout       = 5
  image_uri     = "${aws_ecr_repository.cloudtrail-events-repo.repository_url}:${local.ecr_image_tag}"
  package_type  = "Image"

  role = aws_iam_role.lambda_role.arn

  # Setup here environment variables
  # environment {
  #   variables = {
  #     ENVIRONMENT = var.env_name
  #   }
  # }
}

// Create log group in Cloudwatch
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.cloudtrail-events-parser.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}
