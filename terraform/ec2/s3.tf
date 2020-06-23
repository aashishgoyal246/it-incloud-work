resource "aws_s3_bucket" "Bucket" {

  bucket = "awsitops-bucket"
  region = "${var.region}"
  force_destroy = true
  acl = "public-read"

}

resource "aws_s3_bucket_policy" "policy" {

  bucket = "${aws_s3_bucket.Bucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.Bucket.arn}/*",
                "${aws_s3_bucket.Bucket.arn}"
            ]
        }
    ]
}
POLICY
}
