provider "google" {
  project = var.project
}

data "google_project" "project" {
}

# gke

module "gke" {
  project = var.project
  source  = "./modules/gke"
}

module "gce" {
  project = var.project
  source  = "./modules/gce"
}

# dns

resource "google_project_service" "dns" {
  service = "dns.googleapis.com"
}

resource "google_dns_managed_zone" "default" {
  name     = "default"
  dns_name = "${var.domain_base}."

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "default-record" {
  name         = "${var.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [module.gke.ingress_ip]

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "default-wildcard-record" {
  name         = "*.${var.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [module.gke.ingress_ip]

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "challenge-wildcard-record" {
  name         = "*.challenge.${var.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [module.gke.ingress_ip]

  depends_on = [
    google_project_service.dns,
  ]
}

resource "google_dns_record_set" "smuggling-record" {
  name         = "*.smuggling.challenge.${var.domain_base}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [module.gce.instance_ip]

  depends_on = [
    google_project_service.dns,
  ]
}
