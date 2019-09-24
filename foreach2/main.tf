provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
}

variable "ingress_ports" {
  type = list(number)
  description = "list of ingress ports"
  default = [8000, 8001]
}

resource "aws_security_group" "hanumans_sg" {
  name = "hanumans"
  description = "Ingress for hanumans"
  vpc_id = "vpc-83c5f8e7"

  dynamic "ingress" {
#    iterator = tempvar
    for_each = var.ingress_ports
    content {
      from_port = ingress.value
# from_port = tempvar.value
      to_port = ingress.value
# to_port = tempvar.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "ports" {
  value = aws_security_group.hanumans_sg.ingress.*.from_port
}