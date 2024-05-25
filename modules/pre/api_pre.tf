# Enable base needed apis in GCP
resource "google_project_service" "enable-api-base-cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "google_project_service" "enable-api-base-iam" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.enable-api-base-cloudresourcemanager]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "google_project_service" "enable-api-base-serviceusage" {
  service = "serviceusage.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.enable-api-base-iam]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "google_project_service" "enable-api-base" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.enable-api-base-serviceusage]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

