provider "aws" {
    access_key = "-----" // put credentials here
    secret_key = "-----" // put credentials here
    region = "eu-central-1"
}

## Create VPC ##
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-demo-vpc"
  }
}

output "aws_vpc_id" {
  value = aws_vpc.terraform-vpc.id
}

## Security Group ##
resource "aws_security_group" "terraform_private_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.terraform-vpc.id
  name        = "terraform_ec2_private_sg"

    ingress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1  // For ICMP Ping (from any port to any)
  }

    ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389  // For WinRM connection
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }

  ingress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5985
    to_port     = 5985
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5986
    to_port     = 5986
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8888
    to_port     = 8888
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "ec2-private-sg"
  }
}

output "aws_security_gr_id" {
  value = aws_security_group.terraform_private_sg.id
}

## Create Subnet ##
resource "aws_subnet" "main_subnet_central_a" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.2.0/28"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "MainSubnet"
  }
}

resource "aws_subnet" "main_subnet_central_b" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.3.0/28"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "MainSubnet"
  }
}
output "aws_subnet_subnet" {
  value = aws_subnet.main_subnet_central_b.id
}


## Main Internet Gateway for VPC ##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    name = "Main IGW"
  }
}
## Route table for Public subnet ##
resource "aws_route_table" "public_a" {
    vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "Public Route Table a"
  }
}

resource "aws_route_table" "public_b" {
    vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "Public Route Table b"
  }
}

## Association between Public Subnet and Public Route Table ##
resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.main_subnet_central_a.id
  route_table_id = aws_route_table.public_a.id
}

## Association between Public Subnet and Public Route Table ##
resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.main_subnet_central_b.id
  route_table_id = aws_route_table.public_b.id
}

## My instances ##
## instance1 ##
resource "aws_instance" "terraform_inst1" {
  ami = "ami-0fbc0724a0721c688"
  instance_type = "t2.micro"
  private_ip = "10.0.2.4"
  vpc_security_group_ids = [
    aws_security_group.terraform_private_sg.id]
  subnet_id = aws_subnet.main_subnet_central_a.id
  key_name = "terraform-demo"
  // create a pem key and put in the same folder
  associate_public_ip_address = true
#to run the code inside Windows Server 2019
  user_data = <<EOF
    <script>
    Enable-PsRemoting -Force
    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
    netsh advfirewall firewall add rule name="MySite" dir=in localport=8888 protocol=TCP action=allow
    </script>
    <persist>false</persist>
    EOF

  tags = {
    Name = "terraform_windows2019_1"
    Environment = "development"
    Project = "DEMO-TERRAFORM"
  }
}

## instance2 ##
resource "aws_instance" "terraform_inst2" {
    ami = "ami-0fbc0724a0721c688"
    instance_type = "t2.micro"
    private_ip = "10.0.3.5"
    vpc_security_group_ids =  [ aws_security_group.terraform_private_sg.id ]
    subnet_id = aws_subnet.main_subnet_central_b.id
    key_name               = "terraform-demo" // create a pem key and put in the same folder
    associate_public_ip_address = true
  #to run the code inside Windows Server 2019
  user_data = <<EOF
    <script>
    Enable-PsRemoting -Force
    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
    netsh advfirewall firewall add rule name="MySite" dir=in localport=8888 protocol=TCP action=allow
    </script>
    <persist>false</persist>
    EOF

    tags = {
      Name              = "terraform_windows2019_2"
      Environment       = "development"
      Project           = "DEMO-TERRAFORM"
    }
}

output "instance_id_list"     { value = [aws_instance.terraform_inst1.*.id] }

## Network Load Balancer ##
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.main_subnet_central_a.id, aws_subnet.main_subnet_central_b.id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 8888
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.terraform-vpc.id
  depends_on = [
    aws_lb.test
  ]
  health_check {
        interval = 10
        path = "/"
        protocol = "HTTP"
        port = 8888
    }
}

resource "aws_lb_target_group_attachment" "tgattach1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.terraform_inst1.private_ip
  port             = 8888
}

resource "aws_lb_target_group_attachment" "tgattach2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.terraform_inst2.private_ip
  port             = 8888
}



resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.test.arn
      port                = 80
      protocol            = "TCP"
      default_action {
        target_group_arn = aws_lb_target_group.test.arn
        type             = "forward"
      }
}
