# Project
project_name = "bustling-surf-240814"
domain_name  = "bustling-surf-240814.example.io"
region       = "europe-southwest1"
zone	       = "europe-southwest1-a"

# Networking Pre
subnets_pre = {
  public = "10.210.0.0/16"
  private = "10.211.0.0/16"
  management = "10.212.0.0/16"
}

# Networking k8s Pre
// Node Pool static spot
k8s_pre = {
  nodes_min = 1
  nodes_max = 1
  #node_type = "n2-custom-2-4096"
  node_type = "e2-small"
  autoscaling = true
  location = "europe-southwest1"
  node_locations = "europe-southwest1-a,europe-southwest1-b,europe-southwest1-c" # should not contain man zone (comma separated, no spaces)

  network_master   = "172.16.100.0/28"
  network_services = "172.16.111.0/24"
  network_pods  = "172.16.112.0/21"
  #network_pods_add_extra  = "172.12.0.0/16"
}

# # Networking k8s Pre GKE
# // Node Pool static dynamic
# k8s_pre_gke = {
#   nodes_min = 0 // Nodes per zone
#   nodes_max = 4 // Nodes per zone
#   #node_type = "e2-custom-4-6144"
#   node_type = "e2-small"
#   autoscaling = true
#   location = "europe-southwest1"
#   node_locations = "europe-southwest1-a,europe-southwest1-b,europe-southwest1-c" # comma separated, no spaces 

#   network_master   = "172.16.20.0/28"
#   network_services = "172.16.16.0/22"
#   network_pods  = "172.14.0.0/16"
# }


# Notification
email_address = "correo1"
email_address_customer = "correo2"

# Management
ips_locales	= ["2.136.29.220"] # Oficina
ips_customer	= ["0.0.0.0"] # Set to 0.0.0.0/0 to open management resources to all
ips_roadwarrior = ["2.136.29.220","35.243.129.42","88.8.213.188"]

credentials_file_path = "./auth/serviceaccount.json"
