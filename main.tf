provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_instance" "bharths_ec2" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  count = 1
  vpc_security_group_ids = [aws_security_group.bharths_sg.id]
  user_data = <<-EOF
         #!/bin/bash
         echo "Hello, World!" > index.html
         nohup busybox httpd -f -p 8080 &
  EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "bharths_sg" {
  name = "terraform-example-instance"
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}