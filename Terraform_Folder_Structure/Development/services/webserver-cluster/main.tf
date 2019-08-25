
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

# Now imagine in the Development environment. We needed to expose an extra port just for testing
# This is now easy to do by adding an aws_security_group_rule resource as below

resource "aws_security_group_rule" "allow_testing_inbound" {
  from_port = 12345
  protocol = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  to_port = 12345
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

# Now imagine in the Development environment. We needed to expose an extra port just for testing
# This is now easy to do by adding an aws_security_group_rule resource as below

resource "aws_security_group_rule" "allow_testing_inbound2" {
  from_port = 9876
  protocol = "tcp"
  security_group_id = module.webserver_cluster.alb_security_group_id
  to_port = 9876
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

