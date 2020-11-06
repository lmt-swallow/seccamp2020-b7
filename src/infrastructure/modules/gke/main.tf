# service

resource "google_project_service" "gke" {
  service = "container.googleapis.com"
}

# service account

resource "google_service_account" "challenge_cluster" {
  account_id   = "challenge-cluster"
  display_name = "Challenge Cluster"
}

resource "google_project_iam_policy" "project" {
  project     = var.project
  policy_data = data.google_iam_policy.gke.policy_data
}

data "google_iam_policy" "gke" {
  binding {
    role = "roles/editor"

    members = [
      "serviceAccount:${google_service_account.challenge_cluster.email}",
    ]
  }
}

# cluster itself

resource "google_container_cluster" "challenge_cluster" {
  name     = "challenges"
  location = "asia-northeast1"

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""
  }

  depends_on = [
    google_project_service.gke,
  ]
}

resource "google_container_node_pool" "challenge_cluster_nodes" {
  name       = "challenges"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.challenge_cluster.name
  node_count = 1

  management {
    auto_repair = true
  }

  node_config {
    service_account = google_service_account.challenge_cluster.name

    machine_type = "n1-standard-2"
  }
}
