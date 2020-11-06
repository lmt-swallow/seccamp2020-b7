# because we can't use any variables before executign `terraform init`...

terraform {
  backend "gcs" {
    bucket = "seccamp2020-b7-internal"
  }
}
