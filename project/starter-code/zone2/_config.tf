terraform {
  backend "s3" {
    bucket = "udacity-tf-vgoni-2-west"
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
