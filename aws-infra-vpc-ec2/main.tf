provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "p-kuligowski-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "p-kuligowski-vpc"
  }
}

resource "aws_subnet" "p-kuligowski-subnet" {
  vpc_id                  = aws_vpc.p-kuligowski-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "p-kuligowski-subnet"
  }
}

resource "aws_internet_gateway" "p-kuligowski-igw" {
  vpc_id = aws_vpc.p-kuligowski-vpc.id
  tags = {
    Name = "p-kuligowski-igw"
  }
}

resource "aws_route_table" "p-kuligowski-rt" {
  vpc_id = aws_vpc.p-kuligowski-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.p-kuligowski-igw.id
  }

  tags = {
    Name = "p-kuligowski-rt"
  }
}

resource "aws_route_table_association" "p-kuligowski-rta" {
  subnet_id      = aws_subnet.p-kuligowski-subnet.id
  route_table_id = aws_route_table.p-kuligowski-rt.id
}

resource "aws_security_group" "p-kuligowski-sg" {
  name        = "p-kuligowski-sg"
  description = "Allow SSH from 104.219.108.84"
  vpc_id      = aws_vpc.p-kuligowski-vpc.id

  ingress {
    description = "SSH access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["104.219.108.84/32","104.219.109.84/32", "10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "p-kuligowski-sg"
  }
}

resource "aws_instance" "p-kuligowski-ec2" {
  ami                    = "ami-020cba7c55df1f615" # ubuntu
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.p-kuligowski-subnet.id
  vpc_security_group_ids = [aws_security_group.p-kuligowski-sg.id]
  associate_public_ip_address = true
  key_name               = "p-kuligowski-macbook"

  tags = {
    Name = "p-kuligowski-ec2"
  }
}

output "p-kuligowski-ec2-public-ip" {
  description = "Public IP of the p-kuligowski EC2 instance"
  value       = aws_instance.p-kuligowski-ec2.public_ip
}
