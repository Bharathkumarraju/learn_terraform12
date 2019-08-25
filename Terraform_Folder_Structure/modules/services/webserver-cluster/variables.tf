variable "server_port" {
  description = "The port that server will use for HTTP Requests"
  type = number
  default = 8080
}
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}

variable "instance_type" {
  description = "The Type of EC2 instances to run (e.g. t2.micro)"
  type = string
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
  type = number
}

variable "max_size" {
  description = "The maximum number of EC2 instances in the ASG"
  type = number
}

variable "custom_tags" {
  description = "Custom TAGS to set on the Instances on the ASG"
  type = map(string)
  default = {}
}

variable "enable_autoscaling" {
  description = "if set to true, enable auto scaling"
  type = bool
}

variable "enable_new_user_data" {
  description = "If set to true, use the new User Data script"
  type        = bool
}