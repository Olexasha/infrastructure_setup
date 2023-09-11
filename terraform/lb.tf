resource "yandex_lb_target_group" "tg" {
  name = "reddit-tg"
  dynamic "target" {
    for_each = yandex_compute_instance.app.*.network_interface.0.ip_address
    content {
      address   = target.value
      subnet_id = var.subnet_id
    }
  }
}

resource "yandex_lb_network_load_balancer" "load_balancer" {
  name      = "http-load-balancer"
  folder_id = var.folder_id
  type      = "external"

  listener {
    name        = "reddit-listener"
    port        = 80
    target_port = 9292
    protocol    = "tcp"

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.tg.id
    healthcheck {
      name = "http"
      http_options {
        port = 9292
        path = "/"
      }
    }
  }
}
