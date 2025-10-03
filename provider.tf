terraform {

  cloud {

    organization = "Projects_and_deliverables"

    workspaces {
      name = "NoteApp"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }

  required_version = "~> 1.7"
}

provider "aws" {
  region = "ap-southeast-1"
}