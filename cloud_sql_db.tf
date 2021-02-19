resource "google_sql_database" "database" {
  name     = "addoptify-teamcity-sql-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name   = "addoptify-teamcity-mysql-db"
  region = "europe-west2"

  settings {
    tier = "db-n1-standard-1"
    #zone = var.location_zone
    availability_type = "ZONAL"
    disk_size         = 40
    disk_type         = "PD_SSD"
    backup_configuration {
      enabled            = true
      start_time         = "01:00"
      location           = "europe-west2"
      binary_log_enabled = true
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
    location_preference {
      zone = var.location_zone
    }
  }
  database_version = "MYSQL_5_7"
}
