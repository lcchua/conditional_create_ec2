provider "aws" {
  region = var.region
}

output "environment_message" {
  value = var.is_production ? "Production Environment" : "Non-Production Environment"
}

# Use an existing VPC, filtered by vpc_name defined in variables.tf
data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Use an existing subnet, filtered by subnet_name defined in variables.tf
data "aws_subnet" "selected_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

# Use an existing security group, filtered by security group name in variables.tf
data "aws_security_group" "selected_secgrp" {
  filter {
    name    = "tag:Name"
    values  = [var.sg_name]
  }
}
/* resource "aws_security_group" "ec2_sg" {
  name   = var.sg_name
  vpc_id = data.aws_vpc.selected_vpc.id # var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
} */

resource "aws_instance" "sample_ec2_variables" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.aws_subnet.selected_subnet.id
  associate_public_ip_address = true
  # vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  vpc_security_group_ids = [data.aws_security_group.selected_secgrp.id]

  ## Creates one EC2 if to_create == true
  count = var.to_create ? 1 : 0

  tags = {
    Name = var.ec2_name
  }
}
output "ec2_instance_id" {
  description = "ID of the 1st EC2 instance"
  value       = length(aws_instance.sample_ec2_variables) > 0 ? aws_instance.sample_ec2_variables[0].id : "no instance created"
}
output "vpc_id" {
  description = "ID of the vpc used in the EC2 instance"
  value       = data.aws_vpc.selected_vpc.id
}