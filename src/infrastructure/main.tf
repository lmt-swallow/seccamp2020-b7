provider "google" {
  project = var.project
}

data "google_project" "project" {
}

# dns

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
}

resource "google_dns_managed_zone" "default" {
  project = var.project

  name     = "default"
  dns_name = "${var.domain_base}."

  depends_on = [
    google_project_service.dns,
  ]
}

# gke

module "gke" {
  project = var.project
  source  = "./modules/gke"
}
