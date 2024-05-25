// Don't set variables here

# remote configuration
terraform {
  required_version = ">= 1.0"
}

variable "region" {}
variable "project_name" {}
variable "zone" {}
variable "domain_name" {}
variable "ips_beservices" { type = list(string) }
variable "ips_customer" { type = list(string) }
variable "ips_roadwarrior" { type = list(string) }
variable "email_address" {}
variable "email_address_customer" {}
variable "credentials_file_path" {}

#Entorno Pre
variable "subnets_pre" { type = map(string) }
variable "k8s_pre" { type = map(string) }
# variable "k8s_pre_gke" { type = map(string) } // Node Pool Dynamic
