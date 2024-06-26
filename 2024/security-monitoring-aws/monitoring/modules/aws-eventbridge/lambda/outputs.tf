output "rule_arn" {
  value = module.eventbridge.eventbridge_rule_arns.s3_put_object_lambda
}
