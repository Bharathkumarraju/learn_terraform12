variable "tg1" {
default = [
    {
      "name"             = "portraju1"
      "backend_protocol" = "HTTP"
      "backend_port"     = 80
      "slow_start"       = 0
      "backend_path"     = "/"
      "target_type"      = "ip"
    },
    {
      "name"             = "portraju2"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 100
      "backend_path"     = "/test123"
      "target_type"      = "ip"
    },
  ]
}

provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_iam_user" "bharth_user" {
  for_each = var.tg1
  name = each.key
}

