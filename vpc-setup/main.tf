# VPC 
resource "aws_vpc" "login-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "login-vpc"
  }
}

# Subnet For Frontend
resource "aws_subnet" "login-fe-subnet" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-frontend-subnet"
  }
}

# Subnet For API/Backend
resource "aws_subnet" "login-be-subnet" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "login-backend-subnet"
  }
}

# Subnet For Database
resource "aws_subnet" "login-db-subnet" {
  vpc_id     = aws_vpc.login-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "login-database-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "login-igw" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-internet-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "login-public-rt" {
  vpc_id = aws_vpc.login-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.login-igw.id
  }

  tags = {
    Name = "login-public-routes"
  }
}

# Public Association Frontend
resource "aws_route_table_association" "login-public-asc" {
  subnet_id      = aws_subnet.login-fe-subnet.id
  route_table_id = aws_route_table.login-public-rt.id
}

# Public Association Backend
resource "aws_route_table_association" "login-public-asc-2" {
  subnet_id      = aws_subnet.login-be-subnet.id
  route_table_id = aws_route_table.login-public-rt.id
}

# Private Route Table
resource "aws_route_table" "login-Private-rt" {
  vpc_id = aws_vpc.login-vpc.id

  tags = {
    Name = "login-private-routes"
  }
}

# Private Association Database
resource "aws_route_table_association" "login-private-asc" {
  subnet_id      = aws_subnet.login-db-subnet.id
  route_table_id = aws_route_table.login-Private-rt.id
}

# NACL
resource "aws_network_acl" "login-nacl" {
  vpc_id = aws_vpc.login-vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/00"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/00"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "login-nacl"
  }
}

# Secuirty Group Frontend
resource "aws_security_group" "login-fe-sg" {
  name        = "login-fe-sg"
  description = "Allow Frontend Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "login-fe-sg"
  }
}

# SSH Rule
resource "aws_vpc_security_group_ingress_rule" "login-fe-ssh" {
  security_group_id = aws_security_group.login-fe-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP Rule
resource "aws_vpc_security_group_ingress_rule" "login-fe-http" {
  security_group_id = aws_security_group.login-fe-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Egress / Outbound
resource "aws_vpc_security_group_egress_rule" "login-fe-Outbound" {
  security_group_id = aws_security_group.login-fe-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Secuirty Group Backend
resource "aws_security_group" "login-be-sg" {
  name        = "login-be-sg"
  description = "Allow Backend Traffic"
  vpc_id      = aws_vpc.login-vpc.id

  tags = {
    Name = "login-be-sg"
  }
}

# SSH Rule
resource "aws_vpc_security_group_ingress_rule" "login-be-ssh" {
  security_group_id = aws_security_group.login-be-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# HTTP Rule
resource "aws_vpc_security_group_ingress_rule" "login-be-http" {
  security_group_id = aws_security_group.login-be-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

# Egress / Outbound
resource "aws_vpc_security_group_egress_rule" "login-be-Outbound" {
  security_group_id = aws_security_group.login-be-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}