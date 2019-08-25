
provider "aws" {
  profile = "default"
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-development"
  db_remote_state_bucket = "bharaths-terraform-up-and-running"
  db_remote_state_key = "development/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.micro"
  max_size = "5"
  min_size = "2"
}