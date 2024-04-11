terraform {
  backend "s3" {
    bucket         = "defersec-tfstate"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    # You can specify an explicit AWS profile here
    # profile        = "aws-terraform"
  }
}
