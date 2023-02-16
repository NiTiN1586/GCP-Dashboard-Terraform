# Configure the GCP provider
provider "google" {
  credentials = file("lively-nimbus-377015-4102092ba0b9.json")
  project = "lively-nimbus-377015"
  region  = "us-central1 (Iowa)"
  zone    = "us-central1-a"
}
resource "google_monitoring_dashboard" "dashboard"{
  dashboard_json = <<EOF
{
  "category": "CUSTOM",
  "dashboardFilters": [],
  "displayName": "Test_graph",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 5,
        "widget": {
          "title": "VM Instance - CPU utilization [MEAN]",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_MEAN"
                    },
                    "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\"",
                    "secondaryAggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_NONE",
                      "perSeriesAligner": "ALIGN_NONE"
                    }
                  }
                }
              }
            ],
            "thresholds": [],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 7,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 3,
        "widget": {
          "scorecard": {
            "gaugeView": {
              "lowerBound": 0,
              "upperBound": 1
            },
            "thresholds": [],
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "60s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "groupByFields": [],
                  "perSeriesAligner": "ALIGN_MEAN"
                },
                "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
              }
            }
          },
          "title": "VM Instance - CPU utilization [MEAN]"
        },
        "width": 4,
        "xPos": 7,
        "yPos": 0
      }
    ]
  }
}

EOF
}