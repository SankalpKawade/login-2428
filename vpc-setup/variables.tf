# Variables

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

# Variable VPC CIDR
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

# Variable VPC Tenancy
variable "vpc_tenancy" {
  type = string
  default = "default"
}

# Variable VPC Name
variable "vpc_name" {
  type = string
  default = "login"
}

# Variable Public Subnets
variable "public_subnet_cidrs" {
  type = map(string)
  default = {
    frontend = "10.0.0.0/24"
    backend = "10.0.1.0/24" 
  }
}
