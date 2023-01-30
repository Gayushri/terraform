provider "aws" {
        region = "ap-south-1"
}

#Creating vpc, CIDR with tags
resource "aws_vpc" "web" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "web"
  }
}

#Creating public subnets to vpc
resource "aws_subnet" "web-public" {
  vpc_id                        = aws_vpc.web.id
  cidr_block                    = "10.0.1.0/24"
  map_public_ip_on_launch       = "true"
  availability_zone             = "ap-south-1a"

  tags = {
    Name = "web-public"
  }
}

#creating IGW to VPC
resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web"
  }
}

#creating routing table to IGW
resource "aws_route_table" "web-public1" {
  vpc_id = aws_vpc.web.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-gw.id
  }

 tags = {
    Name = "web-public1"
  }
}

#create route associations with pubic
resource "aws_route_table_association" "web-public" {
  subnet_id      = aws_subnet.web-public.id
  route_table_id = aws_route_table.web-public1.id
}


#creating EC2
resource "aws_instance" "server1" {
  ami                           = "ami-0be0a52ed3f231c12"
  instance_type                 = "t2.micro"
  subnet_id                     = aws_subnet.web-public.id
  associate_public_ip_address   = true
  key_name                      = "Pkey"

  tags = {
    Name = "server1"
  }
}

                          