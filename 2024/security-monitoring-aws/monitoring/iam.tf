data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
   actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

// Lambda assume IAM role
resource "aws_iam_role" "lambda_role" {
  name               = "AssumeLambdaRole"
  description        = "Role for lambda to assume lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

data "aws_iam_policy_document" "lambda_iam_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      # "logs:CreateLogStream",
      # "logs:CreateLogGroup",
      # "logs:PutLogEvents",
      "logs:*",
    ]
    # TODO: Maybe you want to further restrict the target resources here
    resources = ["arn:aws:logs:*:*:*"]
  }
}

// IAM policy for the AWS Lambda
resource "aws_iam_policy" "lambda_iam_policy" {
  name        = "LambdaIAMPolicy"
  description = "Policy for the AWS Lambda"
  policy      = data.aws_iam_policy_document.lambda_iam_policy_document.json
}

# Attach lambda_iam_policy to Lambda's IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_iam_policy.arn 
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudtrail-events-parser.arn
  principal     = "events.amazonaws.com"
  source_arn    = module.aws-eventbridge-Lambda.rule_arn
}
