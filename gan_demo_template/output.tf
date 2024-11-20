output "notebook_url" {
  value = "http://${module.compute.public_ip[0]}:8888/lab"
}
