resource "aws_launch_configuration" "Conf" {

  name = "LC"
  image_id = "ami-0f630a3f40b1eb0b8"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.aashish-key.key_name}"
  security_groups = ["${aws_security_group.SG-1.id}","${aws_security_group.SG-2.id}","${aws_security_group.SG-3.id}"]
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.s3-profile.name}"
  user_data = "${data.template_file.user-data.rendered}"
  depends_on = [

    aws_instance.EC2-1,

  ]

}
