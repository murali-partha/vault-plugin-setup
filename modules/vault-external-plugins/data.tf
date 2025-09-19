

data "cloudinit_config" "vault-install-config" {

part {
    content_type = "text/x-shellscript"
    content = file("${path.module}/systemd/vault-service.sh")
}

part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/vault-config.sh.tmpl", {
      node_id     = 1
      log_level   = var.log_level
      public_ip   = aws_eip.vault_server_elastic_ip.public_ip 
    })
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/install-vault.sh.tmpl", {
})
  }

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/run-vault.sh.tmpl", {
    })
  }
    part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/install-plugins.sh.tmpl", {
      install_all_plugins     = "true"
      install_aerospike_plugin = "true"
    })
  }
}

