resource "aws_iam_role" "s3-role" {
  name = "s3-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {

    Name = "s3-role"

  }
  depends_on = [

    aws_s3_bucket.Bucket,

  ]

}

resource "aws_iam_instance_profile" "s3-profile" {
 
  name = "s3-profile"
  role = "${aws_iam_role.s3-role.name}"

}

resource "aws_iam_role_policy" "s3-policy" {
 
  name = "s3-policy"
  role = "${aws_iam_role.s3-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],
            "Resource": "${aws_s3_bucket.Bucket.arn}/*"
        }
    ]
}
EOF
}
