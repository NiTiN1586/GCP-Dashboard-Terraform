# Configure the GCP provider
provider "google" {
  credentials = file("lively-nimbus-377015-4102092ba0b9.json")
  project = "lively-nimbus-377015"
  region  = "us-central1 (Iowa)"
  zone    = "us-central1-a"
}
# Define the dashboard
resource "google_monitoring_dashboard" "example" {
  dashboard_json = jsonencode({
    "title": "Example Dashboard",
    "widgets": [
      {
        "title": "CPU Utilization",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\"",
                  "perSeriesAligner": "ALIGN_MEAN",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "groupByFields": ["resource.zone"]
                },
                "unitOverride": "PERCENT"
              },
              "plotType": "LINE"
            }
          ],
          "yAxis": {
            "label": "CPU Utilization (%)"
          }
        }
      },
      {
        "title": "High CPU Utilization Alert",
        "threshold": {
          "label": "High CPU Utilization Alert",
          "color": "#FF0000",
          "direction": "above",
          "value": 90,
          "duration": "60s",
          "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
        }
      }
    ]
  })
}

# Define the alert policy
resource "google_monitoring_alert_policy" "example" {
  display_name = "CPU Utilization Alert"
  combiner     = "OR"

  conditions {
    display_name = "High CPU Utilization"
    condition_threshold {
      filter             = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration           = "60s"
      comparison         = "COMPARISON_GT"
      threshold_value    = 90
      aggregations {
        alignment_period  = "60s"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.id
  ]
}

# Define the email notification channel
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Channel"
  type         = "email"

  labels = {
    email_address = "goudanush40@gmail.com"
  }
}
