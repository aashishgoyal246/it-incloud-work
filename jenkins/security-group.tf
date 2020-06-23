resource "aws_security_group" "SG-1" {

  name = "All"
  description = "This is my all traffic group"
  vpc_id = "${aws_vpc.VPC.id}"
  ingress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {

    Name = "My-All"

  }

}
