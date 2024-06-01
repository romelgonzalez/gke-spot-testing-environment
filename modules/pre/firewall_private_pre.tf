#
# VPC Network: private
#
resource "google_compute_firewall" "private-to-public" {
  name          = "${var.environment}-private-to-public"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre]

  allow {
    protocol    = "tcp"
    ports       = ["5432"]
  }

  source_tags   = ["${var.environment}-private"]
  target_tags   = ["${var.environment}-public"]

}

# resource "google_compute_firewall" "private-to-management" {
#   name          = "${var.environment}-private-to-management"
#   network       = "${var.environment}-vpc"
#   depends_on    = [google_compute_network.vpc-pro]

#   allow {
#     protocol    = "tcp"
#     ports       = ["6379"]
#   }

#   source_tags =   ["${var.environment}-private"]
#   target_tags   = ["${var.environment}-management"]
# }

