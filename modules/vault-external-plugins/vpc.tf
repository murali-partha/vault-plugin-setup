resource "aws_vpc" "vault-server-vpc" {

  region = var.region
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "vault-server-vpc-${var.id}"
  }
}

resource "aws_subnet" "public_subnet" {

  region = var.region
  vpc_id     = aws_vpc.vault-server-vpc.id
  depends_on = [ aws_vpc.vault-server-vpc ]
  availability_zone       = "${var.region}a"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 0)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "vault-public-subnet-${var.id}"
  }
}

resource "aws_eip" "vault_server_elastic_ip" {
  domain = "vpc"
  tags = {
    Name = "Vault Server EIP ${var.id}"
  }
}
resource "aws_eip_association" "vault_server_elastic_ip_association" {
depends_on = [ aws_eip.vault_server_elastic_ip, aws_instance.vault-server, aws_internet_gateway.vault_server_igw ]
  instance_id   = aws_instance.vault-server.id
  allocation_id = aws_eip.vault_server_elastic_ip.id

}

resource "aws_internet_gateway" "vault_server_igw" {
  vpc_id = aws_vpc.vault-server-vpc.id

  tags = {
    Name = "Vault Server IGW ${var.id}"
  }
}

resource "aws_route_table" "vault_server_route_table" {
  vpc_id = aws_vpc.vault-server-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vault_server_igw.id
  }

  tags = {
    Name = "vault-server-route-table-${var.id}"
  }
}

resource "aws_main_route_table_association" "vault_server_main_route_table_association" {
  route_table_id = aws_route_table.vault_server_route_table.id
  vpc_id         = aws_vpc.vault-server-vpc.id
}