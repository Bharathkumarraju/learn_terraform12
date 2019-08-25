locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
}

# Variables aren't allowed in a backend configuration..
terraform {
  backend "s3" {
    bucket = "bharaths-terraform-up-and-running"
    key = "development/services/webserver-cluster/terraform.tfstate"
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

data terraform_remote_state "db" {
  backend = "s3"
  config = {
    bucket = var.db_remote_state_bucket
    key = var.db_remote_state_key
    region = "us-east-2"
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
  vars = {
    server_port = var.server_port
    db_address = data.terraform_remote_state.db.outputs.Address
    db_port = data.terraform_remote_state.db.outputs.port
  }
}


resource "aws_launch_configuration" "bharaths_launchconfig" {
  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  security_groups = [aws_security_group.bharths_sg.id]
  user_data = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bharaths_ASG" {
  launch_configuration = "${aws_launch_configuration.bharaths_launchconfig.name}"
  vpc_zone_identifier = data.aws_subnet_ids.bharath_subnets.ids
  target_group_arns = [aws_lb_target_group.bharaths_asg_targetgroup.arn]
  health_check_type = "ELB"
  max_size = var.max_size
  min_size = var.min_size
  tag {
    key = "Name"
    propagate_at_launch = true
    # Each tag must be specified as an inline block—that is, an argument you set within a resource of the format:
    value = "${var.cluster_name}"
  }
  # when using for_each with a list, the key will be the index and the value will be the item in the list at that index
  # when using for_each with a map, the key and value will be one of the key-value pairs in the map.
  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_lb" "bharaths_ALB" {
  name = "${var.cluster_name}"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.bharath_subnets.ids
  security_groups = [aws_security_group.bharaths_alb_securitygroup.id]
}

resource "aws_lb_listener" "bharaths_alb_listener" {
  load_balancer_arn = aws_lb.bharaths_ALB.arn
  port = local.http_port
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
  name = "${var.cluster_name}"
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
  name = "${var.cluster_name}-alb"
}
resource "aws_security_group_rule" "allow_http_inbound" {
  from_port = local.http_port
  protocol = local.tcp_protocol
  security_group_id = aws_security_group.bharaths_alb_securitygroup.id
  to_port = local.http_port
  cidr_blocks = local.all_ips
  type = "ingress"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  from_port = local.any_port
  protocol = local.any_protocol
  security_group_id = aws_security_group.bharaths_alb_securitygroup.id
  to_port = local.any_port
  type = "egress"
  cidr_blocks = local.all_ips
}


resource "aws_security_group" "bharths_sg" {
  name = "${var.cluster_name}-instance"
  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
}