resource "aws_internet_gateway" "GW" {

  vpc_id = "${aws_vpc.VPC.id}"
  tags = {

    Name = "My-IG"

  }

}

