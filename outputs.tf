
output "instruction" {
  value = "\nexport VAULT_ADDR=http://${module.vault-external-plugins.vault-address-public_ip}:8200\n\nYour Vault server has already been initialized and unsealed. Find the unseal keys and root token in the vault-init.json file in the current directory.\n"
}