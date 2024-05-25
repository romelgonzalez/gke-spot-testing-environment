
resource "google_compute_network" "vpc-pre" {
  name 		= "${var.environment}-gke-vpc"
  auto_create_subnetworks = "false"
  depends_on = [google_project_service.enable-api-base]
}

resource "google_compute_subnetwork" "subnets-pre" {
  provider = google-beta
  name     = "${var.environment}-${element(keys(var.subnets_pre), count.index)}-gke-subnet"
  count		 = length(keys(var.subnets_pre))

  ip_cidr_range = element(values(var.subnets_pre), count.index)
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre] 
  private_ip_google_access = true

#  enable_flow_logs = true
#  log_config {
#    aggregation_interval = "INTERVAL_10_MIN"
#    flow_sampling = 0.5
#    metadata = "INCLUDE_ALL_METADATA"
#  }
}

// Subnet Proxy
resource "google_compute_subnetwork" "subnet-proxy" {
  provider = google-beta
  name     = "${var.environment}-gke-proxy-subnet"

  ip_cidr_range = "10.162.0.0/16"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre] 
}



// Router
resource "google_compute_router" "router" {
  name          = "${var.environment}-gke-router"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_subnetwork.subnets-pre]
}

resource "google_compute_address" "nat-ip-address" {
  name        	= "${var.environment}-gke-nat-ip-address"
  depends_on    = [google_compute_subnetwork.subnets-pre]  
}

// NAT for Private subnets-pre
resource "google_compute_router_nat" "simple-nat" {
  name                               = "${var.environment}-gke-nat"
  router                             = google_compute_router.router.name
  depends_on                         = [google_compute_router.router, google_compute_address.nat-ip-address]
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat-ip-address.self_link]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                             = "projects/${var.project_name}/regions/${var.region}/subnetworks/${var.environment}-private-gke-subnet"
    source_ip_ranges_to_nat          = ["ALL_IP_RANGES"]
  }

  lifecycle {
    ignore_changes  = [id, subnetwork]
  }
}

// Output to create subnets pre dependency 
output "vpc_subnets_pre" {
  value       = google_compute_subnetwork.subnets-pre[0].name
  depends_on  = [google_compute_subnetwork.subnets-pre]
}

