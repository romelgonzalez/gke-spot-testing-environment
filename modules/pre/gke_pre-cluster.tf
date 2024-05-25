resource "google_project_service" "enable-api-gke" {
 service = "container.googleapis.com"
 disable_on_destroy = false
}

resource "google_container_cluster" "gke-cluster-01-pre" {
  provider = google-beta
  name       = "${var.environment}-rml"
  location   = var.region
  network    = "projects/${var.project_name}/global/networks/${var.environment}-gke-vpc"
  subnetwork = "projects/${var.project_name}/regions/${var.region}/subnetworks/${var.environment}-private-gke-subnet"
  depends_on = [google_project_service.enable-api-gke,google_compute_subnetwork.subnets-pre]
  deletion_protection = false #permite eliminar el cluster con destroy 

  release_channel {
    channel = "STABLE"
  }
  

  node_locations = split(",", trimspace(var.k8s_pre.node_locations))

  addons_config {
      horizontal_pod_autoscaling {
          disabled  = true
      }
      http_load_balancing {
          disabled  = false
      }
      network_policy_config {
          disabled = true
      }
      gcp_filestore_csi_driver_config {
           enabled = true
      }

  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block   = var.k8s_pre.network_pods
    services_ipv4_cidr_block  = var.k8s_pre.network_services
  }

#  maintenance_policy {
#    daily_maintenance_window {
#      start_time = "03:00"
#    }
#  }

  maintenance_policy {
    recurring_window {
      start_time = "2019-01-01T02:00:00Z"
      end_time = "2019-01-01T06:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
    }
  }

  cluster_autoscaling {
#    enabled = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }


  workload_identity_config {
      workload_pool = "${var.project_name}.svc.id.goog"
        }


  master_authorized_networks_config {
      cidr_blocks {
          cidr_block = var.subnets_pre.management
          display_name  = "${var.environment}-gke-management-subnet"
      }
      cidr_blocks {
          cidr_block   = "213.195.115.115/32"
          display_name = "casa-romel"
      }

      cidr_blocks {
          cidr_block   = "2.136.29.220/32"
          display_name = "beservices"
      }

  } 

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
#    username = ""
#    password = ""
    client_certificate_config {
      issue_client_certificate = true
    }    
  }

  private_cluster_config {
#    enable_private_endpoint = true
    enable_private_endpoint = false  # boolean  false creates a cluster control plane with a publicly-reachable endpoint
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.k8s_pre.network_master
  }

  lifecycle {
    ignore_changes  = [id, master_auth]
  }  
}

// Node pool dynamic
# resource "google_container_node_pool" "k8s-pre-gke-nodes-dynamic-01" {
#   provider = google-beta
#   name       = "${var.environment}-k8s-gke-node-pool-dynamic-01"
#   location   = var.region
#   cluster    = google_container_cluster.gke-cluster-01-pre.name
#   node_count = var.k8s_pre_gke.nodes_min

#   dynamic "autoscaling" {
#     for_each = var.k8s_pre_gke.autoscaling ? [1] : []
#     content {
#       min_node_count = var.k8s_pre_gke.nodes_min
#       max_node_count = var.k8s_pre_gke.nodes_max
#     }
#   }

#   node_config {
#     preemptible  = false
#     machine_type = var.k8s_pre_gke.node_type
#     disk_size_gb = "20"
#     disk_type    = "pd-ssd"
#     image_type   = "cos_containerd"
#     spot         = "true"
#     tags         = ["${var.environment}-k8s-node-pool", "private"]

#     workload_metadata_config {
#             mode = "GKE_METADATA"
#                 }

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     #service_account = google_service_account.kubernetes.email
#     oauth_scopes = [
#         "https://www.googleapis.com/auth/monitoring",
#         "https://www.googleapis.com/auth/devstorage.read_only",
#         "https://www.googleapis.com/auth/logging.write",
#         "https://www.googleapis.com/auth/service.management.readonly",
#         "https://www.googleapis.com/auth/servicecontrol",
#         "https://www.googleapis.com/auth/trace.append"
#       #  "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }

#   lifecycle {
#     ignore_changes  = [
#       autoscaling[0].min_node_count,
#       node_count
#     ]
#   }
# }

// Node Pool static spot
resource "google_container_node_pool" "k8s-pre-nodes-static" {
 provider = google-beta
 name       = "${var.environment}-k8s-node-pool-spot"
 location   = var.region
 cluster    = google_container_cluster.gke-cluster-01-pre.name
 node_count = var.k8s_pre.nodes_min


 node_config {
   preemptible  = false
   machine_type = var.k8s_pre.node_type
   disk_size_gb = "10"
   disk_type    = "pd-ssd"
   image_type   = "cos_containerd"
   spot	 = "true"
   tags         = ["${var.environment}-k8s-node-pool", "private"]

   metadata = {
     disable-legacy-endpoints = "true"
   }

   oauth_scopes = [
       "https://www.googleapis.com/auth/monitoring",
       "https://www.googleapis.com/auth/devstorage.read_only",
       "https://www.googleapis.com/auth/logging.write",
       "https://www.googleapis.com/auth/service.management.readonly",
       "https://www.googleapis.com/auth/servicecontrol",
       "https://www.googleapis.com/auth/trace.append"
   ]
 }

 lifecycle {
   ignore_changes  = [
     autoscaling[0].min_node_count,
     node_count
   ]
 }
}

output "client_certificate-pre" {
  value = google_container_cluster.gke-cluster-01-pre.*.master_auth.0.client_certificate
}

output "client_key-pre" {
  value = google_container_cluster.gke-cluster-01-pre.*.master_auth.0.client_key
}

output "cluster_ca_certificate-pre" {
  value = google_container_cluster.gke-cluster-01-pre.*.master_auth.0.cluster_ca_certificate
}

// Firewall rule from pods to private subnet.
resource "google_compute_firewall" "from-pods-gke-to-private-subnet" {
 name          = "${var.environment}-from-pods-gke-to-private-subnet"
 network       = "${var.environment}-gke-vpc"
 depends_on    = [google_compute_network.vpc-pre]

 allow {
   protocol    = "all"
 }

 source_ranges = [var.k8s_pre.network_pods]
 target_tags   = ["private"]
}


