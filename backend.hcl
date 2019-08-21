# terraform init -backend-config=backend.hcl

bucket         = "bharaths-terraform-up-and-running"
region         = "us-east-2"
dynamodb_table = "bharaths-terraform-up-and-running-locks"
encrypt        = true