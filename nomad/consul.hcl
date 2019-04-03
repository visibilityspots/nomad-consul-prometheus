job "consul" {
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

    task "consul" {
      driver = "docker"

      config {
        image = "consul:1.4.4"
        force_pull = true
        network_mode = "host"
        logging {
          type = "journald"
          config {
            tag = "CONSUL"
          }
        }
      }

      service {
        name = "consul"
        port = "http"

        check {
          type = "http"
          path = "/ui"
          interval = "10s"
          timeout = "2s"
        }

      }

      resources {
        cpu    = 50
        memory = 100

        network {
          port "http" { static = "8500" }
        }
      }
    }
  }
}
