provider "aws" {
  
  version = "~> 2.50.0"
  region = "${var.region}"

}

provider "template" {

  version = "~> 2.1.2"

}
