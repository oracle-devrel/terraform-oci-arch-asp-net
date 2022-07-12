## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_load_balancer" "lb1" {
  shape = var.lb_shape

  dynamic "shape_details" {
    for_each = local.is_flexible_lb_shape ? [1] : []
    content {
      minimum_bandwidth_in_mbps = var.flex_lb_min_shape
      maximum_bandwidth_in_mbps = var.flex_lb_max_shape
    }
  }

  compartment_id = var.compartment_ocid

  subnet_ids = [
    oci_core_subnet.subnet1.id
  ]

  display_name = "lb1"
  reserved_ips {
    id = oci_core_public_ip.test_reserved_ip.id
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = oci_load_balancer.lb1.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}



resource "oci_load_balancer_path_route_set" "test_path_route_set" {
  #Required
  load_balancer_id = oci_load_balancer.lb1.id
  name             = "pr-set1"

  path_routes {
    #Required
    backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
    path             = "/example/video/123"

    path_match_type {
      #Required
      match_type = "EXACT_MATCH"
    }
  }
}

resource "oci_load_balancer_hostname" "test_hostname1" {
  #Required
  hostname         = "app.example.com"
  load_balancer_id = oci_load_balancer.lb1.id
  name             = "hostname1"
}

resource "oci_load_balancer_hostname" "test_hostname2" {
  #Required
  hostname         = "app2.example.com"
  load_balancer_id = oci_load_balancer.lb1.id
  name             = "hostname2"
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = oci_load_balancer.lb1.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb-bes1.name
  hostname_names           = [oci_load_balancer_hostname.test_hostname1.name, oci_load_balancer_hostname.test_hostname2.name]
  port                     = 80
  protocol                 = "HTTP"
  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = oci_load_balancer.lb1.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = oci_core_instance.instance1.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = oci_load_balancer.lb1.id
  backendset_name  = oci_load_balancer_backend_set.lb-bes1.name
  ip_address       = oci_core_instance.instance2.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}
