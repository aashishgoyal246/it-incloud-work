resource "aws_key_pair" "aashish-key" {
  
  key_name = "aashish-key"
  public_key = file("${var.public_key}")

}
