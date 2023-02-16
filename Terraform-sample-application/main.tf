# Configure the GCP provider
provider "google" {
  credentials = file("lively-nimbus-377015-4102092ba0b9.json")
  project = "lively-nimbus-377015"
  region  = "us-central1 (Iowa)"
  zone    = "us-central1-a"
}

# Create a Compute Engine instance for the web server
resource "google_compute_instance" "web" {
  name         = "web-instance"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Use ephemeral IP for simplicity
    }
  }

  metadata_startup_script = "echo 'Hello, World!' > index.html && python3 -m http.server 80"
}

# Create a Compute Engine instance for the application server
resource "google_compute_instance" "app" {
  name         = "app-instance"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Use ephemeral IP for simplicity
    }
  }

  metadata_startup_script = "echo 'Hello, World!' > index.html && python3 -m http.server 80"
}
