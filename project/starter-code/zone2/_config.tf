terraform {
  backend "s3" {
    bucket = "vgonibucketwest"
    key    = "terraform/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "usw1"
  region = "us-west-1"
}
