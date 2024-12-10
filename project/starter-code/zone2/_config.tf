terraform {
   backend "s3" {
     bucket = "udacity-tf-vgoni-west"
     key    = "terraform/terraform.tfstate"
     region = "us-west-1"
   }
 }

 provider "aws" {
   region = "us-west-1"
   default_tags {
     tags = local.tags
   }
 }