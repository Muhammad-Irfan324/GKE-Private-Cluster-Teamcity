terraform {
  backend "gcs" {
    bucket = "state-storage-bucket-addoptify-terraform"
    prefix = "terraform/state"
  }
}
