#------------------------VARIABLES--------------------------------

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




#--------------------------PROVIDERS------------------------------

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