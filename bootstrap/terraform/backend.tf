terraform {
  backend "s3" {
    bucket       = "k3s-observability-tfstate-520728855361-eu-west-1"
    key          = "bootstrap/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
