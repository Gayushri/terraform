provider "aws" {
        region = "ap-south-1"
}

#Creating vpc, CIDR with tags
resource "aws_vpc" "web" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "web"
  }
}

#Creating public subnets to vpc
resource "aws_subnet" "web-public" {
  vpc_id                        = aws_vpc.web.id
  cidr_block                    = "10.0.0.0/25"
  map_public_ip_on_launch       = "true"
  availability_zone             = "ap-south-1a"

  tags = {
    Name = "web-public"
  }
}

#Creating private subnets to vpc
resource "aws_subnet" "web-private" {
  vpc_id                        = aws_vpc.web.id
  cidr_block                    = "10.0.0.128/26"
  map_public_ip_on_launch       = "false"
  availability_zone             = "ap-south-1b"

  tags = {
    Name = "web-private"
  }
}

#creating IGW to VPC
resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web"
  }
}

#creating routing table to public
resource "aws_route_table" "web-public-gw" {
  vpc_id = aws_vpc.web-public-gw.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-public-gw.id
  }

 tags = {
    Name = "web-public-gw"
  }
}

#creating routing table to private
resource "aws_route_table" "web-private-gw" {
  vpc_id = aws_vpc.web-private-gw.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-private-gw.id
  }

 tags = {
    Name = "web-private-gw"
  }
}


#create route associations with public
resource "aws_route_table_association" "web-public" {
  subnet_id      = aws_subnet.web-public.id
  route_table_id = aws_route_table.web-public-gw.id
}

#create route associations with private
resource "aws_route_table_association" "web-private" {
  subnet_id      = aws_subnet.web-private.id
  route_table_id = aws_route_table.web-private-gw.id
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

                          
