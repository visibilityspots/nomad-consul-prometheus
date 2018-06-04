job "node-exporter" {
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

    task "node-exporter" {
      driver = "docker"

      config {
        image = "prom/node-exporter:v0.16.0"
        force_pull = true
        volumes = [
	  "/proc:/host/proc",
	  "/sys:/host/sys",
	  "/:/rootfs"
        ]
        port_map {
          http = 9100
        }

      }

      service {
        name = "node-exporter"
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
          port "http" { static = "9100" }
        }
      }
    }
  }
}

