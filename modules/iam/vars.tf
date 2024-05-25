// Don't set variables here

variable "project_name" {}
variable "credentials_file_path" {}

provider "google" {
  project     = var.project_name
  credentials = file("${var.credentials_file_path}")
}

