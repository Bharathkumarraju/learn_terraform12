variable "server_port" {
  description = "The port that server will use for HTTP Requests"
  type = number
  default = 8080
}

variable "aws_region" {
  default = "us-east-2"
  description = "AWS Region Name"
}

variable "aws_profile" {
  default = "default"
  description = "AWS Profile"
}
