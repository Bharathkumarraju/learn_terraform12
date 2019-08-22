provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_db_instance" "bharaths_mysql" {
  instance_class = "db.t2.micro"
  identifier_prefix = "bharaths-terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  name = "bharaths_example_database"
  username = "bharath_admin"
  password = ""
}