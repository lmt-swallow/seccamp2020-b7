output "gce_ip" {
  value = google_compute_global_address.default.address
}
