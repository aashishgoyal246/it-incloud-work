resource "aws_autoscaling_group" "AS" {

  name = "AS"
  min_size = 1
  max_size = 2
  launch_configuration = "${aws_launch_configuration.Conf.name}"
  vpc_zone_identifier = ["${aws_subnet.Subnet.id}"]
  depends_on = [

    aws_launch_configuration.Conf,

  ]

}

resource "aws_autoscaling_policy" "ASP" {

  name = "ASP"
  autoscaling_group_name = "${aws_autoscaling_group.AS.name}"
  policy_type = "SimpleScaling"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"

}
