terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
	region = "ap-south-1"
        access_key = "AKIAXPH3XV36SCC2XOMI"
        secret_key = "5/DXRn686+62IrgETuxDVEj/75MMlSWBJ4t+qTaH"
}
resource "aws_instance" "example" {
	ami = "ami-02eb7a4783e7e9317"
	instance_type = "t2.medium"
	vpc_security_group_ids = ["sg-09b386f86bcc2ad4e"]
	key_name = "medicure"
	
	connection {
		type = "ssh"
		host = self.public_ip
		user = "ubuntu"
		private_key = file("medicure.pem")
	}
	
	root_block_device {
      		volume_size = 20
      		volume_type = "gp2"
   	}
	
     	tags = {
        	Name = "Test-server"
  	}
	provisioner "local-exec" {
        	command = " echo ${aws_instance.example.public_ip} > inventory "
  }
}
