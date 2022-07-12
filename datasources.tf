## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_region_subscriptions" "home_region_subscriptions" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

data "oci_core_images" "this" {
  compartment_id           = var.compartment_ocid # Required
  operating_system         = var.image_os         # Optional
  operating_system_version = var.image_os_version # Optional
  shape                    = var.instance_shape   # Optional
  sort_by                  = "TIMECREATED"        # Optional
  sort_order               = "DESC"               # Optional
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_limits_services" "compute_services" {
  compartment_id = var.tenancy_ocid

  filter {
    name   = "name"
    values = ["compute"]
  }
}

# Use the cloudinit.ps1 as a template and pass the instance name, user and password as variables to same
data "template_file" "cloudinit_ps1" {
  vars = {
    instance_user     = "opc"
    instance_password = var.instance_password #random_string.instance_password.result
    instance_name     = var.instance_name
  }

  template = file("${path.module}/${var.userdata}/${var.cloudinit_ps1}")
}

data "template_cloudinit_config" "cloudinit_config" {
  gzip          = false
  base64_encode = true

  # The cloudinit.ps1 uses the #ps1_sysnative to update the instance password and configure winrm for https traffic
  part {
    filename     = "cloudinit.ps1"
    content_type = "text/x-shellscript"
    content      = data.template_file.cloudinit_ps1.rendered
  }

  # The cloudinit.yml uses the #cloud-config to write files remotely into the instance, this is executed as part of instance setup
  part {
    filename     = "cloudinit.yml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/${var.userdata}/${var.cloudinit_config}")
  }
}

data "oci_core_instance_credentials" "instance_credentials1" {
  instance_id = oci_core_instance.instance1.id
}

data "oci_core_instance_credentials" "instance_credentials2" {
  instance_id = oci_core_instance.instance2.id
}
