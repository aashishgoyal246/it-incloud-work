resource "aws_subnet" "Subnet" {

  vpc_id = "${aws_vpc.VPC.id}"
  cidr_block = "${var.subnet_cidr[0]}"
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  tags = {

    Name = "Public-Subnet"

  }

}
