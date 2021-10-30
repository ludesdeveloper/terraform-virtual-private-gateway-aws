resource "aws_security_group" "cloud_allow_ssh" {
  name        = "remote_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.cloud_vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloud-allow-ssh"
  }
}

resource "aws_security_group" "cloud_allow_incoming_for_app" {
  name        = "remote_allow_ssh_incoming_for_app"
  description = "Allow incoming web traffic"
  vpc_id      = aws_vpc.cloud_vpc.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloud-allow-incoming-for-app"
  }
}

resource "aws_security_group" "cloud_allow_ingress" {
  name        = "remote_allow_ingress"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.cloud_vpc.id
  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }
  tags = {
    Name = "cloud-allow-ingress"
  }
}

resource "aws_security_group" "cloud_allow_outbound" {
  name        = "remote_allow_outbound"
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.cloud_vpc.id
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloud-allow-outbound"
  }
}










resource "aws_security_group" "on_prem_allow_ssh" {
  name        = "remote_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.on_prem_vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "on-prem-allow-ssh"
  }
}

resource "aws_security_group" "on_prem_allow_incoming_for_app" {
  name        = "remote_allow_ssh_incoming_for_app"
  description = "Allow incoming web traffic"
  vpc_id      = aws_vpc.on_prem_vpc.id
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "on-prem-allow-incoming-for-app"
  }
}

resource "aws_security_group" "on_prem_allow_ingress" {
  name        = "remote_allow_ingress"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.on_prem_vpc.id
  ingress {
    protocol  = -1
    from_port = 0
    to_port   = 0
    self      = true
  }
  tags = {
    Name = "on-prem-allow-ingress"
  }
}

resource "aws_security_group" "on_prem_allow_outbound" {
  name        = "remote_allow_outbound"
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.on_prem_vpc.id
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "on-prem-allow-outbound"
  }
}
