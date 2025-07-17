provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "ap_south"
  region = "ap-south-1"
}

# Get default VPCs
data "aws_vpc" "default_east" {
  provider = aws.us_east
  default  = true
}

data "aws_vpc" "default_south" {
  provider = aws.ap_south
  default  = true
}

# Security group for us-east-1
resource "aws_security_group" "nginx_sg_east" {
  provider    = aws.us_east
  name        = "nginx-sg-east"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default_east.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for ap-south-1
resource "aws_security_group" "nginx_sg_south" {
  provider    = aws.ap_south
  name        = "nginx-sg-south"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default_south.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in us-east-1
resource "aws_instance" "east_instance" {
  provider                  = aws.us_east
  ami                       = "ami-0889a44b331db0194"  # Ubuntu 20.04
  instance_type             = "t2.micro"
  key_name                  = "terraform-key"  # 👈 us-east-1
  vpc_security_group_ids    = [aws_security_group.nginx_sg_east.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              systemctl start nginx
              EOF

  tags = {
    Name = "East-Nginx"
  }
}

# EC2 Instance in ap-south-1
resource "aws_instance" "south_instance" {
  provider                  = aws.ap_south
  ami                       = "ami-0f58b397bc5c1f2e8"  # Ubuntu 20.04
  instance_type             = "t2.micro"
  key_name                  = "linux-ssh-key"  # 👈 ap-south-1
  vpc_security_group_ids    = [aws_security_group.nginx_sg_south.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              systemctl start nginx
              EOF

  tags = {
    Name = "South-Nginx"
  }
}
