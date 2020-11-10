# because we can't use any variables before executign `terraform init`...

terraform {
  backend "gcs" {
    bucket = "seccamp-2020-b7"
  }
}
