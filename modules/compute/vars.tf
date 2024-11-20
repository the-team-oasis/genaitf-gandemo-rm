# Variables passed into compute module

variable "region" {}
variable "compartment_ocid" {}
variable "availability_domain" {}
variable "num_nodes" {
    default = 1
}
variable "public_subnet_ocid" {}
#variable "tflbsubnet_ocid" {}
variable "name_prefix" {}
variable "freeform_tags" {
  default = {
    "key" = "gan"
  }
}

variable "instance_shape" {
    default = "VM.GPU2.1"
}
variable "source_id" {
    default = "ocid1.image.oc1.iad.aaaaaaaafu2o775gx25xn2qk44ja2m4tgkpy2qucgry5yzwgdyw2cvty2iha"
}