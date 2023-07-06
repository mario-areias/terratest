terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "terratest" { # Creating VPC here
  cidr_block = "10.0.0.0/24"     # Defining the CIDR block use 10.0.0.0/24 for demo
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.terratest.id
  cidr_block = "10.0.0.192/26" # CIDR block of private subnets
}

resource "aws_security_group" "security_group" {
  name        = "security_group"
  description = "A Security group"
  vpc_id      = aws_vpc.terratest.id
}

resource "aws_instance" "terratest_ec2" {
  ami                    = "ami-830c94e3"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

