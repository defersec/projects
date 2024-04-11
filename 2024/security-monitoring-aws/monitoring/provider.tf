provider "aws" {
  region  = "eu-central-1"
  profile = "aws-terraform"

  default_tags {
    tags = {
      app = "cloudtrail-events-using-lambda-and-go"
      managed_by = "terraform"
    }
  }
}
