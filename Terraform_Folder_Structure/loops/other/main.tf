resource "aws_instance" "example_1" {
  count = length(data.aws_availability_zones.all.names)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

data "aws_availability_zones" "all" {

}