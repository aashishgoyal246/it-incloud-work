resource "aws_vpc" "VPC" {

  cidr_block = "${var.vpc_cidr}"
  tags = {

    Name =  "My-VPC"

  }

}

