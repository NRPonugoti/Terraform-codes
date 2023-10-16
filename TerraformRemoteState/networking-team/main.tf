provider "aws" {
	region = "ap-south-1"
}

resource "aws_eip" "my-public-ip" {
	vpc = true 
}
output "eip_addr" {
	value  = aws_eip.my-public-ip.public_ip
}
terraform {
	backend "s3" {
		bucket = "name of bucket "
		key = "network/eip.tfstate"
		region = "ap-south-1"
	}
}
