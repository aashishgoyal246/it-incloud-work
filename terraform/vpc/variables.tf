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

