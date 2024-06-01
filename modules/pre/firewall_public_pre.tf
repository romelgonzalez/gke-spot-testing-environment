##
## VPC internet-to-public firewall configuration
#
resource "google_compute_firewall" "internet-to-public-http-server" {
 name          = "${var.environment}-internet-to-public-http"
 network       = "${var.environment}-gke-vpc"
 depends_on    = [google_compute_network.vpc-pre]

 allow {
   protocol    = "tcp"
   ports       = ["80"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags   = ["http-server"]
}

resource "google_compute_firewall" "internet-to-public-https-server" {
 name          = "${var.environment}-internet-to-public-https"
 network       = "${var.environment}-gke-vpc"
 depends_on    = [google_compute_network.vpc-pre]

 allow {
   protocol    = "tcp"
   ports       = ["443"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags   = ["https-server"]
}

#
# VPC Network: public
# 
resource "google_compute_firewall" "public-to-private" {
  name          = "${var.environment}-public-to-private"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre]

  allow {
    protocol    = "all"
  }

  source_tags   = ["${var.environment}-public"]
  target_tags   = ["${var.environment}-private"]

}

resource "google_compute_firewall" "public-to-management" {
  name          = "${var.environment}-public-to-management"
  network       = "${var.environment}-gke-vpc"
  depends_on    = [google_compute_network.vpc-pre]

  allow {
    protocol    = "all"
  }   

  source_tags =   ["${var.environment}-public"]
  target_tags   = ["${var.environment}-management"]
}


