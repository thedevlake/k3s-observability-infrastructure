terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.72.0"
    }
  }

  backend "s3" {
    bucket       = "k3s-observability-tfstate-520728855361-eu-west-1"
    key          = "infrastructure/networking/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
