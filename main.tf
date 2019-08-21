#------------------------VARIABLES-----------------------------------------------------------------------------------------

variable "number_example" {
  description = "An example of number variable in Terraform"
  type = number
  default = 18
}

variable "list_example" {
  description = "An example of a list in Terraform"
  type        = list
  default     = ["a", "b", "c"]
}

# Combine type constraints, Here is list input variable that requires all the items in the list to be numbers

variable "list_numeric_example" {
  description = "An example of numeric list in Terraform"
  type = list(number)
  default = [1, 2, 3]
}

variable "list_string_example" {
  description = "An example of string list in Terraform"
  type = list(string)
  default = ["hanuaman1", "hanuman2", "hanuman3"]
}

# here is map that requires all the values to be strings
variable "map_example" {
  description = "An example of a map in Terraform"
  type = map(string)
  default = {
    "name": "raju"
    "age": 32
    "dob": "12-june-1987"
  }
}

# Create more complicated structural types using object and tuple type constraints

variable "object_example" {
  description = "An example of structural type in Terraform"
  type = object({
    name = string
    age = number
    tags = list(string)
    enabled = bool
  })
  default = {
    name = "raju123"
    age = 32
    tags = ["a", "b", "c"]
    enabled = true
  }
}



variable "object_example_with_error" {
  description = "An example of a structural type in Terraform with an Error"
  type = object({
    name = string
    age = number
    tags = list(string)
    enabled = bool
  })
  default = {
    name = "raju123"
    age = 33
    tags = ["a", "b", "c"]
    enabled = "true"
  }
}


variable "server_port" {
  description = "The port that server will use for HTTP Requests"
  type = number
  default = 8080
}

#--------------------------PROVIDERS---------------------------------------------------------------------------------------

provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "aws_instance" "bharths_ec2" {
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


#----------------------------------------------OUTPUTS---------------------------------------------------------------------

output "bharaths_ec2_publicip" {
  value = aws_instance.bharths_ec2.*.public_ip
  description = "The public IP Address of the web server"
}

output "bharaths_ec2_publicdns" {
  value = aws_instance.bharths_ec2.*.public_dns
  description = "The Public DNS of the web server"
}

output "bharath_ec2_0_public_ip" {
  value = aws_instance.bharths_ec2[0].public_ip
  description = "public ip of first instance"
}

output "bharath_ec2_0_public_dns" {
  value = aws_instance.bharths_ec2[0].public_dns
  description = "Public DNS of first instance"
}

output "bharath_ec2_1_public_ip" {
  value = aws_instance.bharths_ec2[1].public_ip
  description = "Public ip of the second instance"
}
output "bharath_ec2_1_public_dns" {
  value = aws_instance.bharths_ec2[1].public_dns
  description = "public DNS of second instance"
}