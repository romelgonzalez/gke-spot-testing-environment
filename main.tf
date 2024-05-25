terraform {
  backend "gcs" { }
}


module "iam" {
  source       = "./modules/iam/"
  project_name = var.project_name

  credentials_file_path = var.credentials_file_path
}

module "pre" {
  source       = "./modules/pre/"
  environment  = "pre"
  project_name = var.project_name
  region       = var.region
  zone         = var.zone
  domain_name  = var.domain_name
  ips_beservices = var.ips_beservices
  ips_customer = var.ips_customer
  ips_roadwarrior = var.ips_roadwarrior
  
  subnets_pre      = var.subnets_pre
  k8s_pre          = var.k8s_pre  // Node Pool Dynamic
#  k8s_pre_gke      = var.k8s_pre_gke  // Node Pool Static

  credentials_file_path = var.credentials_file_path
}