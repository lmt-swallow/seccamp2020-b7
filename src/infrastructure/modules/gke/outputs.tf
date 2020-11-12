output "ingress_ip" {
  value = google_compute_global_address.challenge_cluster_external_ip.address
}
