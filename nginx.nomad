job "nginx" {
  datacenters = ["dc1"]

  type = "service"

  group "nginx-service" {
    count = 1
    volume "nginxvol" {
      type      = "host"
      read_only = false
      source    = "nginxvol"
    }
    network {
      port "http" {
        to = 80
      }
    }
    service {
      name = "nginx"
      tags = ["global", "nginx"]
      port = "http"

    }
    task "nginx" {
      # The "driver" parameter specifies the task driver that should be used to
      # run the task.
      driver = "docker"

      # The "config" stanza specifies the driver configuration, which is passed
      # directly to the driver to start the task. The details of configurations
      # are specific to each driver, so please see specific driver
      # documentation for more information.
      config {
        image = "nginx:local"
        ports = ["http"]
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }

      volume_mount {
        volume      = "nginxvol"
        destination = "/usr/share/nginx/html"
        read_only   = false
      }
      env {
        PG_USER = "invoicify_dev"
        PG_PASSWORD = "password"
        PG_DATABASE = "invoicify_dev"
        JWT_SECRET = "lsdkjfa;woeijf;aweijf;siljfs"
      }
    }
  }
}
