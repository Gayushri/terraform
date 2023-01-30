provider "aws" {
    
    region     = "ap-south-1"
}

resource "aws_instance" "first_instance" {
    ami           = "ami-0be0a52ed3f231c12"
    instance_type = "t2.micro"
        tags = {
         Name = "server1"
        }

resource "aws_vpc" "first-vpc" {
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
}


