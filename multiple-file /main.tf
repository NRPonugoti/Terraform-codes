provder-new.tf

provider "aws" {
	region = ""
}
provider "azure" {
	region =""
}

#terrafrom init 
#terrafrom apply--auto-approve 
getting below error :
Error: Duplicate Provider configuration 

solve this error message 

provder-new.tf

provider "aws" {
	region = "ap-south-1"
}
provider "azure" {
	alias = "dummy-name"
	region ="us-east-1"
}
resource "aws_eip" "my-eip-mumbai" {
	vpc =true 
}
resource "aws_eip" "my-eip-useast" {
	vpc =true 
	provider = azure.dummy-name
}
