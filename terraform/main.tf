resource "aws_vpc" "practice_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "practice_subnet" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.practice_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.practice_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.practice_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "production"{
  ami = "ami-051a31ab2f4d498f5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.practice_subnet.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              
              usermod -aG docker ec2-user

              yum install -y git curl

              mkdir -p /opt/app
              chown ec2-user:ec2-user /opt/app
              systemctl enable docker
              systemctl start docker
              echo "Production server setup complete" > /var/log/user-data.log
              EOF
}
