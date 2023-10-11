provider "aws" {
	region = ""
}
#create vpc 
resource "aws_vpc" "vpc-demo" {
	cidr_block = "10.0.0.0/16"
	
	tag {
		name = "eve-demo-vpc"
	}
	}
	

#create subnet 
resource "aws_subnet" "subnet-demo" {
	vpc_id = aws_vpc.vpc-demo.id
	availability_zone =""
	cidr_block =10.0.1.0/24
	tag {
		name = "eve-demo-subnet"
	}
}

# internet gate way 

resource "aws_internet_gateway" "ig-demo" {
	vpc_id = aws_vpc.vpc-demo.id
	
	tags = {
		Name = "eve-demo-ig"
	}
}
#Create custome route table 
resource "aws_route_table" "route-demo" {
	vpc_id = aws_vpc.vpc-demo.id 
	route {
	cidr_block = "0.0.0.0/0"   
	#this means all traffic is allowed 
			gateway_id =aws_internet_gateway.ig-demo
	}
		route {
	cidr_block = "::0"   
	#this means all traffic is allowed 
			gateway_id =aws_internet_gateway.ig-demo
	}
	}
#Associate route table to subnet 
resoruces "aws_route_table_association"  "a"{
	subnet_id = aws_subnet.subnet-demo.id
	route_table_id = aws_route_table.route-demo.id
 
}
#Create security group 

resource "aws_security_group" "allow_web" {
	name = "allow_web_traffic"
	description = "Allow web inbound traffic"
	vpc_id = aws_vpc.vpc-demo.id
	
	ingress {
		description ="HTTP"
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		}
		
	ingress {
		description ="SSH"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		}
	egress {
		description ="HTTP"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}
		
		tags {
			Name = "allow_web"
		}
		
}

#ENI -Create a Network_interface 
resoruces "aws_network_interface" "web-server-nic" {
	subnet_id = aws_subnet.subnet-demo.id
	private_ips = ["10.0.1.50"]
	security_group = [aws_security_group.allow_web.id]
}
#Create elastic_Ip

resoruces "aws_eip" "one" {
	vpc = true 
	network_interface = aws_network_interface.web-server-nic.id 
	associate_with_private_ip = "10.0.1.50"
	depends_on = [aws_internet_gateway.gw]
}
#Create AWS-Instance 

resoruces "aws_instance" "web-server-instance1" {
	ami =""
	instance_type= ""
	availability_zone = ""
	key_name = "terraform_demo"
	
	depends_on = [aws-eip.one]
		network_interface {
		 device_index = 0
		 network_interface_id =aws_network_interface.web-server-nic.id 
		}
	user_data = <<-EOF 
				 #!/bin/bash
				 sudo yum update -y
				 sudo yum install httpd -y 
				 sudo systemctl start httpd 
				 sudo bash -c 'echo Learning Terraform on AWS !!> /var/www/html/index.html '
				 EOF
	tags  {
		Name = "web-server "
	}
					
}
}
#nano main.tf 
#terraform init 
#terraform apply --auto-approve 
#terrafrom state list


Key_name : Create .pEM formet 
then luanch ec2 instance
#sudo su -
#mkdir vpc+ec2+demo
#cd vpc+ec2+demo
#nano terraform-demo.pem
paste key info here 

then 
save it 
