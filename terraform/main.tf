
# --------------------
# ----------------------
# SSH Key
# ----------------------
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/barsha/.ssh/id_rsa.pub")  # Using public key path
}

# ----------------------
# Security Group (SSH + HTTP)
# ----------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# ----------------------
# Latest Ubuntu 22.04 AMI
# ----------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Official Ubuntu owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ----------------------
# EC2 Instance
# ----------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "HelloWorld-Web"
  }
}

# ----------------------
# Elastic IP
# ----------------------
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  
}
