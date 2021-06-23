#default vpc taken from aws console
variable "vpc_id" {
    type= "string"
    default= "vpc-24b1535d"
  
}

variable "amiid" {}

# creating security group
resource "aws_security_group" "avengers_ec2_sg" {
  name        = "avengers_ec2_sg"
  description = "avengers sg security group for ec2"
  #vpc_id      = "${var.vpc_id}"

  ingress { #inbound
    description = "SSH from Outside"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #inbound
    description = "nginx port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #outbound
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#providing ami
variable "ami_id" {
    default= "ami-0fc970315c2d38f01"
}

#creating instance
resource "aws_instance" "avengers_ec2_instance" {
  ami                    = "${var.amiid}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.avengers_ec2_sg.id}"]
  user_data = "${file("userdata.sh")}"
  #key_name = "london"
  tags = {
    Name = "avengers_ec2_instance"
  }
}

output "avengers_ec2_ip" {
    value="${aws_instance.avengers_ec2_instance.public_ip}"
}