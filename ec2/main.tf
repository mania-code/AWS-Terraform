resource "aws_key_pair" "my_key" {
    key_name = "terraform-key"
    public_key = file("mania.pub")
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_sg" {
  name        = "terraform-sg"
  description = "TF generated security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }

  tags = {
    Name = "automated-sg"
  }
}


resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [ aws_security_group.my_sg.name ]
    instance_type = var.instance_type
    ami = var.image_id
    user_data = file("install_nginx.sh")
    root_block_device {
      volume_size = var.root_block_size
      volume_type = "gp3"
    }

    tags =  {
        Name = "mania-automated-instance"
    } 
}