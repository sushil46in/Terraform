resource azurerm_linux_virtual_machine" "rancher_vm"{
  connection {
    type     = "ssh"
    user     = "rancheradmin"
    password = "Virgin123123"
    host     = "self.public_ip"
  }

  provisioner "remote-exec" {
    inline = [
      "ifconfig"
    ]
  }
}