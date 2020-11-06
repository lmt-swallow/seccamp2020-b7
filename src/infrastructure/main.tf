provider "google" {
  project = var.project
}

data "google_project" "project" {
}

resource "google_dns_managed_zone" "default" {
  project = var.project

  name     = "default"
  dns_name = "${var.domain_base}."
}

module "gke" {
  project = var.project
  source  = "./modules/gke"
}
