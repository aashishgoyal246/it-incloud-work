variable "region" {

  default = "eu-west-1"

}

variable "vpc_cidr" {

  default = "10.1.0.0/16"

}

variable "subnet_cidr" {

  type = "list"
  default = ["10.1.0.0/24"]

}

data "aws_availability_zones" "azs" {}

variable "private_ip" {

  type = "list"
  default = ["10.1.0.25"]

}

variable "private_key" {
  
  default = "aashish-key"

}

variable "public_key" {

  default = "aashish-key.pub"

}

variable "username" {
  
  default = "ubuntu"

}
