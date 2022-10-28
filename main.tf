terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  // Replace with your key
  credentials = file("ap-endava-workshop-f7f2429b066f.json")

  project = "ap-endava-workshop"
  region  = "us-east1"
  zone    = "us-east1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "ap-gcpvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-subnet" {
  ip_cidr_range = "10.1.1.0/24"
  name = "ap-subnet"
  network = google_compute_network.vpc_network.name
  region = "us-east1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "ap-vm1"
  machine_type = "e2-medium"
  tags = ["allow-ssh", "allow-http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.network-subnet.name
    access_config {
    }
  }
  metadata_startup_script = "mkdir /tmp/work; cd /tmp/work; wget https://raw.githubusercontent.com/apineyro/ap-iac-endava/master/installapp.sh; chmod +x installapp.sh; sudo ./installapp.sh | tee /tmp/script.log"
}

resource "google_compute_firewall" "ap-firewall" {
  name    = "ap-firewall-rule"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  
  //direction = INGRESS
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["allow-ssh", "allow-http"]
}
