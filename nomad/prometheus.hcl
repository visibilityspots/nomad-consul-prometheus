job "prometheus" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"

  group "app" {
    count = 1

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "prometheus" {
      driver = "docker"

      config {
        image = "prom/prometheus:v2.2.1"
        force_pull = true
        network_mode = "host"
  	volumes = [
	    "/opt/prometheus/:/etc/prometheus/"
	]
      }

      service {
        name = "prometheus"
        tags = [
          "metrics"
        ]
        port = "http"

        check {
          type = "http"
          path = "/targets"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu    = 50
        memory = 100

        network {
          port "http" { static = "9090" }
        }
      }
    }
  }
}

