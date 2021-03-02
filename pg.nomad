job "pg" {
  datacenters = ["dc1"]

  type = "service"

  group "pg-service" {
    count = 1

    volume "pgvol" {
      type      = "host"
      read_only = false
      source    = "pgvol"
    }

    network {
      port "pg" {
        to = 5432
      }
    }
    service {
      name = "pg"
      tags = ["global", "pg"]
      port = "5432"

    }
    task "pg" {
      # The "driver" parameter specifies the task driver that should be used to
      # run the task.
      driver = "docker"

      # The "config" stanza specifies the driver configuration, which is passed
      # directly to the driver to start the task. The details of configurations
      # are specific to each driver, so please see specific driver
      # documentation for more information.
      config {
        image = "postgres:13"
        ports = ["pg"]
      }
      volume_mount {
        volume      = "pgvol"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      resources {
        cpu    = 1000
        memory = 512
      }

      env {
        POSTGRES_DB = "invoicify"
        POSTGRES_PASSWORD = "postgres"
        POSTGRES_USER = "invoicify_dev"
      }
    }
  }
}
