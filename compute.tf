## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

/* Instances */

resource "oci_core_instance" "instance1" {
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "ASPNetVM1"
  shape               = var.instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.shape_flex_memory
      ocpus         = var.shape_flex_ocpus
    }
  }

  # Refer cloud-init in https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/LaunchInstanceDetails
  metadata = {
    # Base64 encoded YAML based user_data to be passed to cloud-init
    user_data = data.template_cloudinit_config.cloudinit_config.rendered
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.subnet1.id
    hostname_label = "ASPNetVM1"
  }

  fault_domain = "FAULT-DOMAIN-1"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.this.images[0].id # var.instance_image_ocid[var.region]
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_instance" "instance2" {
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "ASPNetVM2"
  shape               = var.instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.shape_flex_memory
      ocpus         = var.shape_flex_ocpus
    }
  }
  
  # Refer cloud-init in https://docs.cloud.oracle.com/iaas/api/#/en/iaas/20160918/datatypes/LaunchInstanceDetails
  metadata = {
    # Base64 encoded YAML based user_data to be passed to cloud-init
    user_data = data.template_cloudinit_config.cloudinit_config.rendered
  }

  create_vnic_details {
    subnet_id      = oci_core_subnet.subnet1.id
    hostname_label = "ASPNetVM2"
  }

  fault_domain = "FAULT-DOMAIN-2"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.this.images[0].id # var.instance_image_ocid[var.region]
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


