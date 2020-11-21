# service

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

# service accounts

resource "google_service_account" "challenge_gce" {
  account_id   = "challenge-gce"
  display_name = "Challenge on GCE"

  depends_on = [
    google_project_service.iam,
  ]
}

resource "google_project_iam_custom_role" "challenge-gce-role" {
  role_id     = "challenge_gce_role"
  title       = "Challenge Node"
  description = "A role for challenge nodes"
  permissions = ["compute.projects.setCommonInstanceMetadata", "compute.projects.get", "compute.globalOperations.get"]
}

resource "google_project_iam_member" "node" {
  role   = google_project_iam_custom_role.challenge-gce-role.name
  member = "serviceAccount:${google_service_account.challenge_gce.email}"

  depends_on = [
    google_project_iam_custom_role.challenge-gce-role,
    google_project_service.iam,
  ]
}

resource "google_project_iam_member" "node-gcr" {
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.challenge_gce.email}"

  depends_on = [
    google_project_service.iam,
  ]
}

# gce itself

resource "google_compute_firewall" "default" {
  name    = "allow-web"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

resource "google_compute_network" "default" {
  name = "challenge-gce"
}

resource "google_compute_firewall" "allow-access-from-google-infrastructure" {
  name      = "allow-access-from-google-infrastructure"
  network   = google_compute_network.default.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  target_tags = ["web"]
}

resource "google_compute_subnetwork" "default" {
  name          = "challenge-gce-subnet"
  ip_cidr_range = "192.168.1.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.default.name
}

resource "google_compute_instance" "default" {
  name         = "challenge-gce"
  machine_type = "n1-standard-2"
  zone         = "asia-northeast1-a"

  boot_disk {
    initialize_params {
      size  = 256
      type  = "pd-standard"
      image = "debian-cloud/debian-9"
    }
  }

  tags = ["web"]

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    access_config {
      nat_ip = google_compute_address.default.address
    }
  }

  service_account {
    email  = google_service_account.challenge_gce.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_address" "default" {
  region       = "asia-northeast1"
  name         = "challenge-gce"
  address_type = "EXTERNAL"
}
