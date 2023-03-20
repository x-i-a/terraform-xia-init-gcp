# Step 1: Preparation of all needed apis
resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

# Step 2: Get Project informations
resource "google_project" "current_project" {
  name       = "Current Project"
  project_id = var.project_id
}

# Step 3: Create Firestore
resource "google_project_service" "firestore" {
  project = var.project_id
  service = "firestore.googleapis.com"
}

resource "google_firestore_database" "database" {
  project     = var
  name        = "(default)"
  location_id = "location"
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.firestore]
}

resource "google_service_account" "xia_terraform" {
  account_id = var.terraform_user
  project = var.project_id

  depends_on = [google_project_service.iam_api]
}

resource "google_project_iam_binding" "security_admin_binding" {
  project = var.project_id
  role    = "roles/securitycenter.admin"
  members = ["serviceAccount:${google_service_account.xia_terraform.email}"]
  depends_on = [google_service_account.xia_terraform]
}

resource "google_project_iam_binding" "service_usage_admin_binding" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  members = ["serviceAccount:${google_service_account.xia_terraform.email}"]
  depends_on = [google_service_account.xia_terraform]
}

resource "google_project_iam_binding" "service_account_admin_binding" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  members = ["serviceAccount:${google_service_account.xia_terraform.email}"]
  depends_on = [google_service_account.xia_terraform]
}

resource "google_project_iam_binding" "service_account_user_binding" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  members = ["serviceAccount:${google_service_account.xia_terraform.email}"]
  depends_on = [google_service_account.xia_terraform]
}
