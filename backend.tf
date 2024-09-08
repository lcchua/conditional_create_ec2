
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"

  # To comment out backend block if working on local and 
  # terraform state file is locally stored
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "tf-conditional-lcchua-dev.tfstate"
    region = "us-east-1"
  }
}
