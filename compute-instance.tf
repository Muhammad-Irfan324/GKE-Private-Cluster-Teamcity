resource "google_compute_instance" "default" {
  name         = "kubectl-instance"
  machine_type = "e2-medium"
  zone         = var.location_zone
  boot_disk {
    initialize_params {
      image = "terraform-instance-image"
    }

    #source = "terraform-instance-image"
    #https://www.googleapis.com/compute/v1/projects/addoptify/zones/europe-west2/disks/
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name


    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    user-data = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  }

  #metadata_startup_script = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  #metadata_startup_script = file("commands.sh")
  #metadata_startup_script = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project} & kubectl taint node $(kubectl get nodes | grep agent |awk 'NR==1{print $1; exit}') servertype=teamcity-agents:NoSchedule & kubectl taint node $(kubectl get nodes | grep agent |awk 'NR==2{print $1; exit}') servertype=teamcity-agent-3:NoSchedule & kubectl label node $(kubectl get nodes | grep agent |awk 'NR==1{print $1; exit}') servertype=teamcity-agents & kubectl label node $(kubectl get nodes | grep agent |awk 'NR==2{print $1; exit}') servertype=teamcity-agent-3"

  service_account {
    scopes = ["cloud-platform"]
  }


}
