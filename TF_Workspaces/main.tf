provider "aws" {
  profile = "default"
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "bharaths-terraform-up-and-running"
    key = "bharath-workspaces-example/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "bharaths-terraform-up-and-running-locks"
    encrypt = true
  }
}

resource "aws_instance" "hanumans_ec2" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}