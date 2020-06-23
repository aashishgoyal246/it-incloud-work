data "template_file" "user-data" {

  template = "${file("./script.sh")}"

}
