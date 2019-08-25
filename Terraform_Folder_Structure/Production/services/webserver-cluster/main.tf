
provider "aws" {
  profile = "default"
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-production"
  db_remote_state_bucket = "bharaths-terraform-up-and-running"
  db_remote_state_key = "production/data-stores/mysql/terraform.tfstate"
  instance_type = "t2.medium"
  max_size = "5"
  min_size = "2"
  enable_autoscaling = true
  enable_new_user_data = false
}

/*
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name = module.webserver_cluster.autoscaling_group_name
  scheduled_action_name = "scale-out-during-business-hours"
  min_size = 2
  max_size = 6
  desired_capacity = 6
  recurrence = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  autoscaling_group_name = module.webserver_cluster.autoscaling_group_name
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"
}
*/