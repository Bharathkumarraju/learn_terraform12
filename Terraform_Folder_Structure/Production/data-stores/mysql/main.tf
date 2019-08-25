provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


terraform {
  backend "s3" {
    bucket = "bharaths-terraform-up-and-running"
    key = "production/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "bharaths-terraform-up-and-running-locks"
    encrypt = true
  }
}

resource "random_string" "db_password" {
  length = 16
  special = true
  override_special = "!#()-[]<>"
}

resource "aws_db_instance" "bharaths_mysql" {
  instance_class = "db.t2.micro"
  identifier_prefix = "bharaths-terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  name = "prod_bharaths_example_database"
  username = "bharath_admin"
  skip_final_snapshot     =  true
  apply_immediately = true
  password = random_string.db_password.result
  lifecycle {
    ignore_changes = ["password"]
  }
}


