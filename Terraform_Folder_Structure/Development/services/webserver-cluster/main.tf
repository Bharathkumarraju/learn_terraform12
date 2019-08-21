
provider "aws" {
  profile = var.aws_region
  region = var.aws_region
}
# Variables aren't allowed in a backend configuration..
terraform {
  backend "s3" {
    bucket = "bharaths-terraform-up-and-running"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "bharaths-terraform-up-and-running-locks"
    encrypt = true
  }
}

/*resource "aws_instance" "bharths_ec2" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  count = 2
  vpc_security_group_ids = [aws_security_group.bharths_sg.id]
  user_data = <<-EOF
         #!/bin/bash
         echo "Hello, World!" > index.html
         nohup busybox httpd -f -p ${var.server_port} &
  EOF

  tags = {
    Name = "terraform-example"
  }
}*/


data "aws_vpc" "bharaths_vpc" {
  default = true
}

data "aws_subnet_ids" "bharath_subnets"{
  vpc_id = data.aws_vpc.bharaths_vpc.id
}

resource "aws_launch_configuration" "bharaths_launchconfig" {
  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.bharths_sg.id]
  user_data = <<-EOF
         #!/bin/bash
         echo "Hello, World!" > index.html
         nohup busybox httpd -f -p ${var.server_port} &
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bharaths_ASG" {
  launch_configuration = "${aws_launch_configuration.bharaths_launchconfig.name}"
  vpc_zone_identifier = data.aws_subnet_ids.bharath_subnets.ids
  target_group_arns = [aws_lb_target_group.bharaths_asg_targetgroup.arn]
  health_check_type = "ELB"
  max_size = 5
  min_size = 2
  desired_capacity = 2
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-asg-example"
  }
}

resource "aws_lb" "bharaths_ALB" {
  name = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.bharath_subnets.ids
  security_groups = [aws_security_group.bharaths_alb_securitygroup.id]
}

resource "aws_lb_listener" "bharaths_alb_listener" {
  load_balancer_arn = aws_lb.bharaths_ALB.arn
  port = 80
  protocol = "HTTP"
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page Not Found"
      status_code = 404
    }
  }
}


resource "aws_lb_target_group" "bharaths_asg_targetgroup" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.bharaths_vpc.id
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "bharaths_asg_listerner_rule" {
  listener_arn = aws_lb_listener.bharaths_alb_listener.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.bharaths_asg_targetgroup.arn
  }
  condition {
    field = "path-pattern"
    values = ["*"]
  }
}


resource "aws_security_group" "bharaths_alb_securitygroup" {
  name = "terraform-example-alb"

  # Allow inbound HTTP Requests
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outboubnd requests
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bharths_sg" {
  name = "terraform-example-instance"
  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
}