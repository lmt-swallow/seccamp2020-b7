# service

resource "google_project_service" "gke" {
  service = "container.googleapis.com"
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

# service accounts

resource "google_service_account" "challenge_cluster" {
  account_id   = "challenge-cluster"
  display_name = "Challenge Cluster"

  depends_on = [
    google_project_service.iam,
  ]
}

resource "google_service_account" "cert_manager" {
  account_id   = "cert-manager"
  display_name = "Cert Manager"

  depends_on = [
    google_project_service.iam,
  ]
}

resource "google_project_iam_custom_role" "challenge-node-role" {
  role_id     = "challenge_node_role"
  title       = "Challenge Node"
  description = "A role for challenge nodes"
  permissions = ["compute.projects.setCommonInstanceMetadata", "compute.projects.get", "compute.globalOperations.get"]
}

resource "google_project_iam_binding" "node" {
  role = google_project_iam_custom_role.challenge-node-role.name

  members = [
    "serviceAccount:${google_service_account.challenge_cluster.email}",
  ]

  depends_on = [
    google_project_iam_custom_role.challenge-node-role,
  ]
}

resource "google_project_iam_binding" "dns" {
  role = "roles/dns.admin"

  members = [
    "serviceAccount:${google_service_account.cert_manager.email}",
  ]
}


# cluster itself

resource "google_compute_global_address" "challenge_cluster_external_ip" {
  name = "challenge-cluster-external-ip"

  depends_on = [
    google_project_service.compute,
  ]
}

resource "google_container_cluster" "challenge_cluster" {
  name     = "challenges"
  location = "asia-northeast1"

  initial_node_count = 3

  node_config {
    service_account = google_service_account.challenge_cluster.name

    machine_type = "n1-standard-2"
  }

  master_auth {
    username = ""
    password = ""
  }

  depends_on = [
    google_project_service.gke,
    google_project_service.compute,
  ]
}
