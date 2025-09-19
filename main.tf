

module "vault-external-plugins" {
  source = "./modules/vault-external-plugins"

  region        = var.region
  instance_type = var.instance_type
  id            = var.id
  log_level     = var.log_level
  vault_version = var.vault_version
  ebs_volume_size = var.ebs_volume_size
  vpc_cidr      = var.vpc_cidr  
  
}