job "jwt-maker" {
  datacenters = ["dc1"]

  type = "service"

  group "jwt-maker-service" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }
    service {
      name = "jwt-maker"
      tags = ["global", "nginx"]
      port = "http"

    }
    task "jwt-maker" {
      # The "driver" parameter specifies the task driver that should be used to
      # run the task.
      driver = "docker"

      # The "config" stanza specifies the driver configuration, which is passed
      # directly to the driver to start the task. The details of configurations
      # are specific to each driver, so please see specific driver
      # documentation for more information.
      config {
        image = "jwt-maker:local"
        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }

      env {
        PGDATABASE = "invoicify"
        PGHOST= "pg"
        PGPASSWORD = "password"
        PGUSER = "invoicify_dev"
        PORT = 80
        WAIT_HOSTS = "pg:5432,jwt-maker:80"
        WAIT_HOSTS_TIMEOUT = 60
      }
    }
  }
}
