data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # AWS account ID of Canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "template_file" "on_prem_init" {
  template = file("on-prem-init.sh.tpl")

  vars = {
    some_address = "${aws_instance.some.private_ip}"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-for-development"
  public_key = file(var.public_key_file)
}

resource "aws_instance" "cloud_instance" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  #vpc_security_group_ids = [
  #  aws_security_group.allow_ssh.id,
  #  aws_security_group.allow_outbound.id,
  #  aws_security_group.allow_ingress.id,
  #  aws_security_group.allow_incoming_for_app.id
  #]
  network_interface {
    network_interface_id = aws_network_interface.cloud_interface.id
    device_index         = 0
  }
  tags = {
    Name = "cloud-instance"
  }
}

resource "aws_instance" "on_prem_instance" {
  count         = 1
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  user_data     = data.template_file.on_prem_init.rendered
  #source_dest_check = false
  #vpc_security_group_ids = [
  #  aws_security_group.allow_ssh.id,
  #  aws_security_group.allow_outbound.id,
  #  aws_security_group.allow_ingress.id,
  #  aws_security_group.allow_incoming_for_app.id
  #]
  network_interface {
    network_interface_id = aws_network_interface.on_prem_interface.id
    device_index         = 0
  }
  tags = {
    Name = "on-prem-instance-${count.index + 1}"
  }
}
