resource "aws_route_table" "RT-Public" {

  vpc_id = "${aws_vpc.VPC.id}"
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.GW.id}"

  }
  tags = {

    Name = "Public-RT"

  }

}

resource "aws_route_table_association" "Public" {

  subnet_id = "${aws_subnet.Subnet.id}"
  route_table_id = "${aws_route_table.RT-Public.id}"

}
