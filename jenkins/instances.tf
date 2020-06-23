resource "aws_instance" "EC2-1" {

  ami = "ami-0f630a3f40b1eb0b8"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  provisioner "file" {
    source = "./jenkins.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "sudo sh /tmp/script.sh",
    ]
  }
  connection {
    host = self.public_ip
    type = "ssh"
    user = "${var.username}"
    private_key = file("${var.private_key}")
  }
  tags = {

    Name = "Jenkins"

  }
  subnet_id = "${aws_subnet.Subnet.id}"
  private_ip = "${var.private_ip[0]}"
  vpc_security_group_ids = ["${aws_security_group.SG-1.id}"]
  key_name = "${aws_key_pair.aashish-key.key_name}"

}
