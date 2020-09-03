resource "aws_instance" "bastion-1" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

   # user data
user_data = data.template_cloudinit_config.cloudinit-example.rendered

tags = {
    Name = "bastion 1"
  }
}

 

resource "aws_instance" "bastion-2" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-2.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "bastion 2"
  }
}

resource "aws_instance" "ldap-1" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-5.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "ldap 1"
  }
}

resource "aws_instance" "ldap-2" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-6.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "ldap 2"
  }
}

resource "aws_instance" "www-1" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-3.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "www 1"
  }
  
  provisioner "remote-exec" {
    # Install Python for Ansible
    inline = ["sudo dnf -y install python libselinux-python"]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file(var.PATH_TO_PRIVATE_KEY)}"
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ec2-user -i '${self.public_ip},' --private-key ${var.PATH_TO_PRIVATE_KEY} -T 300 ./ansible/gitinstall.yml" 
  }

}

resource "aws_instance" "www-2" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-public-4.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "www 2"
  }
}



resource "aws_instance" "App-1" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-private-1.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "App 1"
  }
}

resource "aws_instance" "App-2" {
  ami           = var.AMIS
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = aws_subnet.main-private-2.id

  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh-bastion.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name

  user_data = data.template_cloudinit_config.cloudinit-example.rendered

  tags = {
    Name = "App 2"
  }
}


resource "aws_ebs_volume" "ebs-bastion" {
  availability_zone = "eu-west-3a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data bastion"
  }
}

resource "aws_ebs_volume" "ebs-bastion-2" {
  availability_zone = "eu-west-3b"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data bastion 2"
  }
}

resource "aws_ebs_volume" "ebs-ldap" {
  availability_zone = "eu-west-3a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data ldap"
  }
}

resource "aws_ebs_volume" "ebs-ldap-2" {
  availability_zone = "eu-west-3b"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data ldap 2"
  }
}

resource "aws_ebs_volume" "ebs-www" {
  availability_zone = "eu-west-3a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data www"
  }
}

resource "aws_ebs_volume" "ebs-www-2" {
  availability_zone = "eu-west-3b"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data www 2"
  }
}

resource "aws_ebs_volume" "ebs-app" {
  availability_zone = "eu-west-3a"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data app"
  }
}

resource "aws_ebs_volume" "ebs-app-2" {
  availability_zone = "eu-west-3b"
  size              = 20
  type              = "gp2"
  tags = {
    Name = "extra volume data app 2"
  }
}





resource "aws_volume_attachment" "ebs-volume-attachment-bastion-1" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-bastion.id
  instance_id  = aws_instance.bastion-1.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-bastion-2" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-bastion-2.id
  instance_id  = aws_instance.bastion-2.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-ldap-1" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-ldap.id
  instance_id  = aws_instance.ldap-1.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-ldap-2" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-ldap-2.id
  instance_id  = aws_instance.ldap-2.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-www-1" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-www.id
  instance_id  = aws_instance.www-1.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-www-2" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-www-2.id
  instance_id  = aws_instance.www-2.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-app-1" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-app.id
  instance_id  = aws_instance.App-1.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}

resource "aws_volume_attachment" "ebs-volume-attachment-app-2" {
  device_name  = var.INSTANCE_DEVICE_NAME
  volume_id    = aws_ebs_volume.ebs-app-2.id
  instance_id  = aws_instance.App-2.id
  skip_destroy = true                            # skip destroy to avoid issues with terraform destroy
}






