# This Terraform script provisions a compute instance

resource "random_id" "random_id" {
  byte_length = 2
}

# Create Compute Instance

resource "oci_core_instance" "compute_instance" {
  count               = var.num_nodes
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name = "${var.name_prefix}-instance-${random_id.random_id.dec}"
  #image = var.image_ocid
  shape = var.instance_shape

  #subnet_id = var.private_subnet_ocid
  freeform_tags = var.freeform_tags

  create_vnic_details {
    subnet_id        = var.public_subnet_ocid
    display_name     = "${var.name_prefix}-primaryvnic-${random_id.random_id.dec}"
    assign_public_ip = true
    #hostname_label   = "${var.name_prefix}-${random_id.random_id.dec}-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  # metadata = {
  #  ssh_authorized_keys = var.ssh_public_key
  # }

  metadata = {
    ssh_authorized_keys = "${tls_private_key.public_private_key_pair.public_key_openssh}"
  }

  timeouts {
    create = "60m"
  }
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm   = "RSA"
}

resource "null_resource" "download_wallet" {
  depends_on = [oci_core_instance.compute_instance[0]]

  provisioner "remote-exec" {
    inline = [
      "echo 'Jupyter Notebook 실행'",
      "nohup jupyter lab --ip 0.0.0.0 --port 8888 > /home/opc/demo/logs/nohup.out 2>&1 &",
      "sleep 10",
      #"cat /home/opc/demo/logs/nohup.out"
      "cat /home/opc/demo/logs/nohup.out | sed -n 's/.*\\(token=[^&]*\\).*/\\1/p' | head -n 1"
    ]

    connection {
      type        = "ssh"
      host        = oci_core_instance.compute_instance[0].public_ip
      user        = "opc"
      private_key = "${tls_private_key.public_private_key_pair.private_key_pem}"
    }
  }
}