resource "google_compute_network" "vpc_network" {
  name                    = var.vpc-name
  description             = "addoptify-vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  mtu                     = 1500
}


resource "google_compute_route" "route-ilb" {
  name             = "default-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "global/gateways/default-internet-gateway"
  priority         = 1000
}
