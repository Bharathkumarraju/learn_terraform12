provider "aws" {
  profile =var.aws_profile
  region = var.aws_region
}

resource "aws_s3_bucket" "bharath_tf_state_store" {
  bucket = "bharaths-terraform-up-and-running"

  # Prevent Accedental Delete of this bucket
  lifecycle {
    prevent_destroy = true
  }
  # Enables versioning
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "bharaths-terraform-locks" {
  hash_key = "LockID"
  name = "bharaths-terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}