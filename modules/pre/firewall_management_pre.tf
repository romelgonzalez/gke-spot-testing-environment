#
# VPC Network: management
# 
resource "google_compute_firewall" "management-to-public" {
  name          = "${var.environment}-management-to-public"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre]

  allow {
    protocol    = "all"
  }

  source_tags   = ["${var.environment}-management"]
  target_tags   = ["${var.environment}-public"]

}

resource "google_compute_firewall" "management-to-private" {
  name          = "${var.environment}-management-to-private"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre]

  allow {
    protocol    = "all"
  }   

  source_tags =   ["${var.environment}-management"]
  target_tags   = ["${var.environment}-private"]
}

