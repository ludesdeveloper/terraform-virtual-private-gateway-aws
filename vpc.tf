resource "aws_vpc" "cloud_vpc" {
  cidr_block = "172.14.0.0/16"

  tags = {
    Name = "cloud-vpc"
  }
}

resource "aws_subnet" "cloud_subnet" {
  vpc_id            = aws_vpc.cloud_vpc.id
  cidr_block        = "172.14.10.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "cloud-vpc"
  }
}

resource "aws_network_interface" "cloud_interface" {
  subnet_id   = aws_subnet.cloud_subnet.id
  private_ips = ["172.14.10.100"]
  security_groups = [
    aws_security_group.cloud_allow_ssh.id,
    aws_security_group.cloud_allow_outbound.id,
    aws_security_group.cloud_allow_ingress.id,
    aws_security_group.cloud_allow_incoming_for_app.id
  ]

  tags = {
    Name = "cloud-vpc"
  }
}

resource "aws_internet_gateway" "cloud_gw" {
  vpc_id = aws_vpc.cloud_vpc.id

  tags = {
    Name = "cloud-gw"
  }
}

resource "aws_route_table" "cloud_route_table" {
  vpc_id = aws_vpc.cloud_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_gw.id
  }
  tags = {
    Name = "cloud-route-table"
  }
}

resource "aws_route_table_association" "cloud_route_assoc" {
  route_table_id = aws_route_table.cloud_route_table.id
  subnet_id      = aws_subnet.cloud_subnet.id
}

resource "aws_eip" "cloud_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.cloud_interface.id
  associate_with_private_ip = "172.14.10.100"
}

resource "aws_vpn_gateway" "cloud_vpn_gw" {
  vpc_id = aws_vpc.cloud_vpc.id

  tags = {
    Name = "cloud-vpn-gw"
  }
}

resource "aws_vpn_connection" "cloud_to_on_prem_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.cloud_vpn_gw.id
  customer_gateway_id = aws_customer_gateway.on_prem_cust_gw.id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "on_prem_vpn_connection_route" {
  destination_cidr_block = "172.16.0.0/16"
  vpn_connection_id      = aws_vpn_connection.cloud_to_on_prem_vpn.id
}

resource "aws_vpc" "on_prem_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "on-prem-vpc"
  }
}

resource "aws_subnet" "on_prem_subnet" {
  vpc_id            = aws_vpc.on_prem_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "on-prem-vpc"
  }
}

resource "aws_network_interface" "on_prem_interface" {
  subnet_id   = aws_subnet.on_prem_subnet.id
  private_ips = ["172.16.10.100"]
  security_groups = [
    aws_security_group.on_prem_allow_ssh.id,
    aws_security_group.on_prem_allow_outbound.id,
    aws_security_group.on_prem_allow_ingress.id,
    aws_security_group.on_prem_allow_incoming_for_app.id
  ]

  tags = {
    Name = "on-prem-vpc"
  }
}

resource "aws_internet_gateway" "on_prem_gw" {
  vpc_id = aws_vpc.on_prem_vpc.id

  tags = {
    Name = "on-prem-gw"
  }
}

resource "aws_route_table" "on_prem_route_table" {
  vpc_id = aws_vpc.on_prem_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.on_prem_gw.id
  }
  tags = {
    Name = "on-prem-route-table"
  }
}

resource "aws_route_table_association" "on_prem_route_assoc" {
  route_table_id = aws_route_table.on_prem_route_table.id
  subnet_id      = aws_subnet.on_prem_subnet.id
}

resource "aws_eip" "on_prem_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.on_prem_interface.id
  associate_with_private_ip = "172.16.10.100"
}

resource "aws_customer_gateway" "on_prem_cust_gw" {
  bgp_asn    = 65000
  ip_address = aws_eip.on_prem_eip.public_ip
  type       = "ipsec.1"

  tags = {
    Name = "main-customer-gateway"
  }
}
