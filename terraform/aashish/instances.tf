resource "aws_instance" "EC2-1" {

  ami = "ami-0f630a3f40b1eb0b8"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  provisioner "file" {
    source = "./script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "sudo sh /tmp/script.sh script@gmail.com",
    ]
  }
  connection {
    host = self.public_ip
    type = "ssh"
    user = "${var.username}"
    private_key = file("${var.private_key}")
  }
  tags = {

    Name = "Server"

  }
  subnet_id = "${aws_subnet.Subnet.id}"
  private_ip = "${var.private_ip[0]}"
  vpc_security_group_ids = ["${aws_security_group.SG-1.id}","${aws_security_group.SG-2.id}","${aws_security_group.SG-3.id}"]
  key_name = "${aws_key_pair.aashish-key.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.s3-profile.name}"
  depends_on = [

    aws_iam_instance_profile.s3-profile,
    aws_s3_bucket.Bucket,

  ]

}

resource "aws_instance" "EC2-2" {

  ami = "ami-0f630a3f40b1eb0b8"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  provisioner "file" {
    source = "./client.sh"
    destination = "/tmp/client.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/client.sh",
      "sudo sh /tmp/client.sh",
    ]
  }
  connection {
    host = self.public_ip
    type = "ssh"
    user = "${var.username}"
    private_key = file("${var.private_key}")
  }
  tags = {
    
    Name = "Client"

  }
  subnet_id = "${aws_subnet.Subnet.id}"
  private_ip = "${var.private_ip[1]}"
  vpc_security_group_ids = ["${aws_security_group.SG-1.id}","${aws_security_group.SG-2.id}","${aws_security_group.SG-3.id}"]
  key_name = "${aws_key_pair.aashish-key.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.s3-profile.name}"
  depends_on = [

    aws_instance.EC2-1,

  ]

}
