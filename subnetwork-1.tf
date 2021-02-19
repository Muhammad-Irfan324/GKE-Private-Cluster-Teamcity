
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.subnet-1
  ip_cidr_range = var.sub-1-cidr-range
  region        = "europe-west2"
  network       = google_compute_network.vpc_network.id

  private_ip_google_access = true
  secondary_ip_range = [{
    range_name    = "my-pods"
    ip_cidr_range = "10.4.0.0/14"
    },
    {
      range_name    = "my-service"
      ip_cidr_range = "10.0.32.0/20"
    }
  ]

}
