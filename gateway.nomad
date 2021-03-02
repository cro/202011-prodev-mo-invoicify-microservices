job "gateway" {
  datacenters = ["dc1"]

  type = "service"

  group "gateway-service" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }
    service {
      name = "gateway"
      tags = ["global", "gateway"]
      port = "http"
    }

    task "gateway" {
      # The "driver" parameter specifies the task driver that should be used to
      # run the task.
      driver = "docker"

      # The "config" stanza specifies the driver configuration, which is passed
      # directly to the driver to start the task. The details of configurations
      # are specific to each driver, so please see specific driver
      # documentation for more information.
      config {
        image = "gateway:local"

        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }

      env {
        PGUSER = "invoicify_dev"
        PGPASSWORD = "password"
        PGDATABASE = "invoicify_dev"
        JWT_SECRET = "lsdkjfa;woeijf;aweijf;siljfs"
        PORT = "80"
        WAIT_HOSTS = "pg:5432,jwt-maker:80"
        WAIT_HOSTS_TIMEOUT = 60
      }
    }
  }
}
