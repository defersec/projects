# Create ECR repository
data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region = "eu-central-1"
  ecr_image_tag = "latest"
  docker_image = "security-monitoring-aws"

}

resource "aws_ecr_repository" "cloudtrail-events-repo" {
  name = "cloudtrail-events-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

# Create ECR repository
resource "null_resource" "ecr_image" {
  # When the Lambda function (a Golang based binary) changes, a new ECR image will be created
  triggers = {
    go_binary = filemd5("../app/build/lambda-function.bin")
  }
  provisioner "local-exec" {
    command = <<EOF
        aws ecr get-login-password  | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com
        docker tag ${local.docker_image}  ${aws_ecr_repository.cloudtrail-events-repo.repository_url}:${local.ecr_image_tag}
        docker push ${aws_ecr_repository.cloudtrail-events-repo.repository_url}:${local.ecr_image_tag}
    EOF
  }
}
