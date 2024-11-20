/*
* This terraform script creates an User, creates Group, adds user to group,
* creates compartment, defines policy for compartment,
* creates virtual cloud network and provisions a compute instance
*/

# Create a Virtual Cloud Network
module "vcn" {
 source              = "../modules/vcn"
 region              = var.region
 compartment_ocid    = var.compartment_ocid
 availability_domain = var.availability_domain
 name_prefix         = var.name_prefix
}

module "compute" {
  source              = "../modules/compute"
  region              = var.region
  availability_domain = var.availability_domain
  compartment_ocid    = var.compartment_ocid
  name_prefix         = var.name_prefix
  public_subnet_ocid  = module.vcn.public_subnet_ocid
}
