provider "aws" {

    region     = "ap-south-1"
}

resource "aws_instance" "first_instance" {
    ami           = "ami-0be0a52ed3f231c12"
    instance_type = "t2.micro"
        tags = {
         Name = "server1"
        }
