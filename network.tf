module "networking" {
  resource "aws_vpc" "first-instance" {
  cidr_block = "10.0.0.0/16"
  tags = {
   Name = "server1_vpc"
    }
  }

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "server1_subnet"
  }
}
