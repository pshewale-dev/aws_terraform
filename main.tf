provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

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

resource "aws_instance" "ansible_node" {
  ami                         = "ami-036c2987dfef867fb" # Update with valid AMI ID
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "AnsibleNode"
  }
}

resource "aws_instance" "ansible_host1" {
  ami                         = "ami-036c2987dfef867fb" # Update with valid AMI ID
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "AnsibleHost1"
  }
}

resource "aws_instance" "ansible_host2" {
  ami                         = "ami-036c2987dfef867fb" # Update with valid AMI ID
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "AnsibleHost2"
  }
}

