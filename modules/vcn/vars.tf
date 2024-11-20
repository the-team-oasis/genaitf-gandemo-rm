# Variables passed into vcn module

variable "region" {}
variable "compartment_ocid" {}
variable "availability_domain" {}
variable "name_prefix" {}
variable "freeform_tags" {
  default = {
    "key" = "gan"
  }
}
