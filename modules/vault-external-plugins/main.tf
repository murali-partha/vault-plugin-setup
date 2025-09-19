
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "vault-ssh-key" {
  algorithm = "RSA"
}

# Vault server's EC2s are dependent on this key
resource "aws_key_pair" "vault-key-pair" {
  region = var.region
  key_name   = "vault-key-pair-${var.id}"
  public_key = tls_private_key.vault-ssh-key.public_key_openssh
   depends_on = [ tls_private_key.vault-ssh-key ]
}

resource "aws_instance" "vault-server" {
  region = var.region
  ami           = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [ aws_security_group.vault.id ]
  instance_type = var.instance_type
  depends_on = [ aws_key_pair.vault-key-pair, tls_private_key.vault-ssh-key, aws_security_group.vault, data.cloudinit_config.vault-install-config, aws_subnet.public_subnet ]
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name = aws_key_pair.vault-key-pair.key_name

  user_data = data.cloudinit_config.vault-install-config.rendered

  tags = {
    Name = "Vault Server ${var.id}"
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.vault-ssh-key.private_key_pem}\" >> ./vault-ssh-private.key"
  }

  provisioner "local-exec" {
    command = "chmod 600 ./vault-ssh-private.key"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm ./vault-ssh-private.key"
    on_failure = continue
  }

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
  }
}

resource "null_resource" "vault-creds" {

  depends_on = [ aws_eip_association.vault_server_elastic_ip_association ]

  provisioner "local-exec" {
    command = "sleep 60 && scp -o StrictHostKeyChecking=no -i ./vault-ssh-private.key ubuntu@${aws_eip.vault_server_elastic_ip.public_ip}:/home/ubuntu/vault-init.json ."
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm ./vault-init.json"
    on_failure = continue
  }

}