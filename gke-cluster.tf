resource "google_container_cluster" "google_container_cluster" {
  project                  = var.project_name
  name                     = format("%s-cluster", var.cluster_name)
  initial_node_count       = var.initial_node_count
  min_master_version       = data.google_container_engine_versions.cluster_engine_version.latest_master_version
  network                  = google_compute_network.vpc_network.name
  subnetwork               = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
  remove_default_node_pool = true
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  location                 = var.location_zone

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.16/28"

  }


  ip_allocation_policy {
    #cluster_ipv4_cidr_block  = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range.0.ip_cidr_range 
    #services_ipv4_cidr_block = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range.1.ip_cidr_range
    cluster_secondary_range_name  = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range.1.range_name

  }

  enable_legacy_abac = true

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_config
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = lookup(cidr_blocks.value, "display_name", null)
      }
    }
  }

  master_auth {
    username = var.cluster_master_username
    password = var.cluster_master_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing
    }
  }

  depends_on = [data.google_container_engine_versions.cluster_engine_version]
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = var.node_pool_name
  location = var.location_zone
  cluster  = google_container_cluster.google_container_cluster.name



  node_config {
    preemptible     = var.preemptible
    machine_type    = var.node_machine_type
    disk_size_gb    = var.node_disk_size_gb
    disk_type       = var.node_disk_type
    tags            = var.node_tags
    oauth_scopes    = var.oauth_scopes
    image_type      = var.os_image_type
    service_account = google_service_account.trusted_zone_cluster_sa.email


    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  initial_node_count = var.initial_node_count
  #autoscaling {
  #  min_node_count = var.min_node_count
  #  max_node_count = var.max_node_count
  #}

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  depends_on = [google_container_cluster.google_container_cluster]


  #provisioner "local-exec" {
  # command = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  # }
  ###Tainting one Worker node and Labelling
  ##provisioner "local-exec" {
  # command = "kubectl taint node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server:NoSchedule"
  #}
  ##provisioner "local-exec" {
  # command = "kubectl label node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server"
  #}
}




resource "google_container_node_pool" "primary_preemptible_nodes-agents-1" {
  name     = var.node_pool_name_second
  location = var.location_zone
  cluster  = google_container_cluster.google_container_cluster.name


  node_config {
    preemptible     = var.preemptible
    machine_type    = var.node_machine_type_agent
    disk_size_gb    = var.node_disk_size_gb
    disk_type       = var.node_disk_type
    tags            = var.node_tags
    oauth_scopes    = var.oauth_scopes
    image_type      = var.os_image_type
    service_account = google_service_account.trusted_zone_cluster_sa.email
    taint = [{

      effect = "NO_SCHEDULE"
      key    = "servertype"
      value  = "teamcity-agent-1"
    }]


    metadata = {
      disable-legacy-endpoints = "true"
    }
  }


  initial_node_count = var.initial_node_count_agent
  #autoscaling {
  #  min_node_count = var.min_node_count
  #  max_node_count = var.max_node_count
  #}

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  depends_on = [google_container_cluster.google_container_cluster]


  # provisioner "local-exec" {
  #   command = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  # }
  ###Tainting one Worker node and Labelling
  ##provisioner "local-exec" {
  # command = "kubectl taint node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server:NoSchedule"
  #}
  ##provisioner "local-exec" {
  # command = "kubectl label node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server"
  #}
}

# kubectl taint node $(kubectl get nodes | grep agent |awk 'NR==1{print $1; exit}') servertype=teamcity-agents:NoSchedule
# kubectl taint node $(kubectl get nodes | grep agent |awk 'NR==2{print $1; exit}') servertype=teamcity-agent-3:NoSchedule

# kubectl label node $(kubectl get nodes | grep agent |awk 'NR==1{print $1; exit}') servertype=teamcity-agents
# kubectl label node $(kubectl get nodes | grep agent |awk 'NR==2{print $1; exit}') servertype=teamcity-agent-3


resource "google_container_node_pool" "primary_preemptible_nodes-agents-2" {
  name     = var.node_pool_name_third
  location = var.location_zone
  cluster  = google_container_cluster.google_container_cluster.name


  node_config {
    preemptible     = var.preemptible
    machine_type    = var.node_machine_type_agent
    disk_size_gb    = var.node_disk_size_gb
    disk_type       = var.node_disk_type
    tags            = var.node_tags
    oauth_scopes    = var.oauth_scopes
    image_type      = var.os_image_type
    service_account = google_service_account.trusted_zone_cluster_sa.email
    taint = [{

      effect = "NO_SCHEDULE"
      key    = "servertype"
      value  = "teamcity-agent-2"
    }]


    metadata = {
      disable-legacy-endpoints = "true"
    }
  }


  initial_node_count = var.initial_node_count_agent
  #autoscaling {
  #  min_node_count = var.min_node_count
  #  max_node_count = var.max_node_count
  #}

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  depends_on = [google_container_cluster.google_container_cluster]


  # provisioner "local-exec" {
  #   command = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  # }
  ###Tainting one Worker node and Labelling
  ##provisioner "local-exec" {
  # command = "kubectl taint node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server:NoSchedule"
  #}
  ##provisioner "local-exec" {
  # command = "kubectl label node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server"
  #}
}


resource "google_container_node_pool" "primary_preemptible_nodes-agents-3" {
  name     = var.node_pool_name_fourth
  location = var.location_zone
  cluster  = google_container_cluster.google_container_cluster.name


  node_config {
    preemptible     = var.preemptible
    machine_type    = var.node_machine_type_agent
    disk_size_gb    = var.node_disk_size_gb
    disk_type       = var.node_disk_type
    tags            = var.node_tags
    oauth_scopes    = var.oauth_scopes
    image_type      = var.os_image_type
    service_account = google_service_account.trusted_zone_cluster_sa.email
    taint = [{

      effect = "NO_SCHEDULE"
      key    = "servertype"
      value  = "teamcity-agent-3"
    }]


    metadata = {
      disable-legacy-endpoints = "true"
    }
  }


  initial_node_count = var.initial_node_count_agent
  #autoscaling {
  #  min_node_count = var.min_node_count
  #  max_node_count = var.max_node_count
  #}

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  depends_on = [google_container_cluster.google_container_cluster]


  # provisioner "local-exec" {
  #   command = "gcloud container clusters get-credentials ${google_container_cluster.google_container_cluster.name} --zone  ${google_container_cluster.google_container_cluster.location} --project ${google_container_cluster.google_container_cluster.project}"
  # }
  ###Tainting one Worker node and Labelling
  ##provisioner "local-exec" {
  # command = "kubectl taint node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server:NoSchedule"
  #}
  ##provisioner "local-exec" {
  # command = "kubectl label node $(kubectl get nodes | grep addoptify |awk 'NR==1{print $1; exit}') servertype=teamcity-server"
  #}
}

