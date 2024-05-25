// Don't set variables here

variable "project_name" {}
variable "region" {}
variable "zone" {}
variable "domain_name" {}
variable "environment" { }
variable "ips_beservices" { type = list(string) }
variable "ips_customer" { type = list(string) }
variable "ips_roadwarrior" { type = list(string) }
variable "subnets_pre" { type = map(string) }
variable "k8s_pre" { type = map(string) }
# variable "k8s_pre_gke" { type = map(string) }
variable "credentials_file_path" {}

provider "google" {
  region  = "${var.region}"
  project = "${var.project_name}"
  zone    = "${var.zone}"

  credentials   = file("${var.credentials_file_path}")
}

provider google-beta {
  region  = "${var.region}"
  project = "${var.project_name}"
  zone    = "${var.zone}"

  credentials   = file("${var.credentials_file_path}")
}


