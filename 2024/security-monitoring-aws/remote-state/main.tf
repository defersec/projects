provider "aws" {
  region = "eu-central-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "defersec-tfstate"
     
  lifecycle {
    prevent_destroy = true
  }
}

# Allow versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
    bucket = aws_s3_bucket.terraform_state.id

    versioning_configuration {
      status = "Enabled"
    }
}
