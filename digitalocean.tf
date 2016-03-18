variable "ssh_keys_id" {}

resource "digitalocean_droplet" "logapp" {
   image = "centos-7-0-x64"
   name  = "logapp"
   region = "sgp1"
   size   = "512mb"
   ssh_keys =  [ "${var.ssh_keys_id}" ]

   provisioner "local-exec" {
      command = "echo ${digitalocean_droplet.webapp.ipv4_address} ${digitalocean_droplet.webapp.name} >> /tmp/hosts.txt"
   }
}
