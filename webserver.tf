resource "aws_instance" "bharths_ec2" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  user_data = <<-EOF
         #!/bin/bash
         sudo service apache2 restart
  EOF
}